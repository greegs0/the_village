class EventsController < ApplicationController
  before_action :set_event, only: [:edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def index
    @events=Event.all
    @event=Event.new
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    if @event.save
      redirect_to events_path, notice: "Evénement créé"
    else
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to events_path, notice: "Evénement modifié avec succès"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Evénement supprimé avec succès"
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def authorize_user
    unless @event.user == current_user
      redirect_to events_path, alert: "Ah non. Tu n'es pas autorisé à effectuer cette action"
    end
  end

  def event_params
    params.require(:event).permit(:name, :date, :place, :description, :category, :max_participations )
  end
end
