class EventsController < ApplicationController
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

  private

  def event_params
    params.require(:event).permit(:name, :date, :place, :description, :category, :max_participations )
  end
end
