class MessagesController < ApplicationController
  before_action :set_chat

  # POST /chats/:chat_id/messages
  def create
    @message = @chat.messages.new(message_params)
    @message.role = "user"

    if @message.save
      # Générer un titre si c'est le premier message utilisateur
      generate_chat_title_if_needed

      # Appeler l'API de l'Assistant IA
      generate_assistant_response
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
end
