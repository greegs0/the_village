class MessagesController < ApplicationController
  before_action :set_chat

  # POST /chats/:chat_id/messages
  def create
    @message = @chat.messages.new(message_params)
    @message.role = "user"

    if @message.save
      # Générer un titre si c'est le premier message utilisateur
      generate_chat_title_if_needed

      # Détecter si l'utilisateur confirme une action
      user_confirmed = user_confirms_action?(@message.content)
      Rails.logger.info "🔍 User confirmed action: #{user_confirmed} (message: '#{@message.content}')"

      actions_executed = false
      if user_confirmed
        actions_executed = execute_pending_actions
      end

      # Appeler l'API de l'Assistant IA seulement si aucune action n'a été exécutée
      unless actions_executed
        generate_assistant_response
      end

      redirect_to families_path(chat_id: @chat.id)
    else
      redirect_to families_path(chat_id: @chat.id), alert: 'Erreur lors de l\'envoi du message.'
    end
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end

  def generate_assistant_response
    # Appeler le service OpenAI avec le contexte de la famille (méthode DRY)
    openai_service = OpenaiService.new
    response_content = openai_service.chat_completion(@chat.messages.chronological, family_context)

    # Créer la réponse de l'assistant
    @chat.messages.create!(
      role: "assistant",
      content: response_content
    )
  end

  def generate_chat_title_if_needed
    # Générer un titre seulement si :
    # 1. Le chat a le titre par défaut "Nouvelle conversation"
    # 2. C'est le premier message utilisateur (excluant le message de bienvenue)
    user_messages_count = @chat.messages.where(role: "user").count

    if @chat.title == "Nouvelle conversation" && user_messages_count == 1
      openai_service = OpenaiService.new
      generated_title = openai_service.generate_chat_title(@message.content)
      @chat.update(title: generated_title)
    end
  end

  # Détecte si l'utilisateur confirme une action (mots-clés français)
  def user_confirms_action?(message_content)
    confirmation_keywords = ['oui', 'ok', 'vas-y', 'vas y', 'fais-le', 'fais le', 'd\'accord', 'daccord', 'accord', 'parfait', 'go', 'allez', 'allons-y']
    message_normalized = message_content.downcase.strip

    confirmation_keywords.any? { |keyword| message_normalized.include?(keyword) }
  end

  # Exécute les actions suggérées dans le message précédent de l'assistant
  # Retourne true si des actions ont été exécutées, false sinon
  def execute_pending_actions
    # Récupérer le dernier message de l'assistant (avant le message utilisateur actuel)
    last_assistant_message = @chat.messages.where(role: "assistant").order(created_at: :desc).first
    Rails.logger.info "🔍 Last assistant message: #{last_assistant_message&.content&.truncate(100)}"
    return false unless last_assistant_message

    # Vérifier si le message contenait une proposition d'action
    has_action_proposal = last_assistant_message.content.include?("Veux-tu que je le fasse")
    Rails.logger.info "🔍 Has action proposal: #{has_action_proposal}"
    return false unless has_action_proposal

    openai_service = OpenaiService.new
    actions_data = openai_service.extract_suggested_actions(last_assistant_message.content, family_context)
    Rails.logger.info "🔍 Actions extracted: #{actions_data.inspect}"

    # Exécuter les actions
    executor = ActionExecutorService.new(current_user, current_user.family)
    results = executor.execute_actions(actions_data)
    Rails.logger.info "🔍 Execution results: #{results.inspect}"

    # Créer un message système pour confirmer les actions créées
    if results[:tasks_created].any? || results[:event_created].present?
      confirmation_message = build_confirmation_message(results)
      @chat.messages.create!(
        role: "assistant",
        content: confirmation_message
      )
      Rails.logger.info "✅ Confirmation message created"
      return true # Des actions ont été exécutées
    else
      Rails.logger.info "⚠️ No tasks or events created"
      return false # Aucune action exécutée
    end
  end

  # Construit un message de confirmation des actions créées
  def build_confirmation_message(results)
    message_parts = ["✅ J'ai créé les éléments suivants pour toi :\n"]

    if results[:event_created]
      event = results[:event_created]
      message_parts << "\n📅 **Événement créé** :"
      message_parts << "- #{event.title} (#{event.formatted_date})"
    end

    if results[:tasks_created].any?
      message_parts << "\n✓ **Tâches créées** :"
      results[:tasks_created].each do |task|
        message_parts << "- #{task.name} → assignée à #{task.assignee.name}"
      end
    end

    if results[:errors].any?
      message_parts << "\n⚠️ **Erreurs** :"
      results[:errors].each do |error|
        message_parts << "- #{error}"
      end
    end

    message_parts << "\nTu peux consulter ces éléments dans ton calendrier et ta liste de tâches !"

    message_parts.join("\n")
  end
end
