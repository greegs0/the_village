class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :destroy]

  # GET /chats
  def index
    @chats = current_user.chats.recent
  end

  # GET /chats/:id
  def show
    @messages = @chat.messages.chronological
    @message = Message.new
  end

  # POST /chats
  def create
    @chat = current_user.chats.new(chat_params)

    if @chat.save
      # Ajouter un message de bienvenue automatique avec le contexte de la famille
      welcome_message = add_welcome_message

      respond_to do |format|
        format.html { redirect_to families_path(chat_id: @chat.id) }
        format.json { render json: { chat: @chat, welcome_message: welcome_message }, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to families_path, alert: 'Erreur lors de la création du chat.' }
        format.json { render json: { errors: @chat.errors }, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/:id
  def destroy
    @chat.destroy
    redirect_to chats_path, notice: 'Chat supprimé avec succès.'
  end

  private

  def set_chat
    @chat = current_user.chats.find(params[:id])
  end

  def chat_params
    params.require(:chat).permit(:title)
  end

  def add_welcome_message
    context = family_context

    welcome_text = if context
      <<~TEXT
        Bonjour ! Je suis l'assistant de The Village. 👋

        Voici un aperçu de votre famille "#{context[:name]}" :
        • Membres : #{context[:members_info]}
        • Code postal : #{context[:zipcodes]}
        • #{context[:tasks_count]} tâche(s) active(s)
        • #{context[:events_count]} événement(s) à venir

        Comment puis-je vous aider aujourd'hui ?
      TEXT
    else
      "Bonjour ! Je suis l'assistant de The Village. Comment puis-je vous aider aujourd'hui ?"
    end

    # Créer et retourner le message de bienvenue
    @chat.messages.create!(
      role: "assistant",
      content: welcome_text
    )
  end
end
