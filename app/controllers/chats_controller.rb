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
      redirect_to @chat, notice: 'Chat créé avec succès.'
    else
      @chats = current_user.chats.recent
      render :index, status: :unprocessable_entity
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
end
