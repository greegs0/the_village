class MessagesController < ApplicationController
  before_action :set_chat

  # POST /chats/:chat_id/messages
  def create
    @message = @chat.messages.new(message_params)
    @message.role = "user"

    if @message.save
      # TODO: Appeler l'API de l'Assistant IA ici
      # Pour l'instant, on redirige simplement vers families avec le chat actif
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
end
