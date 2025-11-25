class MessagesController < ApplicationController
  before_action :set_chat

  # POST /chats/:chat_id/messages
  def create
    @message = @chat.messages.new(message_params)
    @message.role = "user"

    if @message.save
      # TODO: Appeler l'API de l'Assistant IA ici
      # Pour l'instant, on redirige simplement vers le chat
      redirect_to @chat, notice: 'Message envoyé avec succès.'
    else
      @messages = @chat.messages.chronological
      render 'chats/show', status: :unprocessable_entity
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
