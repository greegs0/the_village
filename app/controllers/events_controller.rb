class EventsController < ApplicationController
  before_action :set_event, only: [:update, :destroy, :register, :unregister]
  before_action :authorize_user, only: [:update, :destroy]
  before_action :authenticate_user!, only: [:create, :register, :unregister]

  def index
    @events = Event.includes(:user, :participants).order(date: :desc).page(params[:page]).per(20)
    @event = Event.new

    # Stats (sur tous les événements, pas juste la page courante)
    @stats = {
      total: Event.count,
      upcoming: Event.where('date >= ?', Date.today).count,
      participants: EventRegistration.count,
      locations: Event.distinct.count(:place)
    }
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

  def update
    if @event.update(event_params)
      redirect_to events_path, notice: "Evénement modifié avec succès"
    else
      redirect_to events_path, alert: "Erreur lors de la modification de l'événement"
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Evénement supprimé avec succès"
  end

  def register
    # Transaction avec verrouillage pour éviter la race condition
    Event.transaction do
      @event.lock!
      if @event.full?
        respond_to do |format|
          format.html { redirect_to events_path, alert: "Cet événement est complet" }
          format.json { render json: { success: false, message: "Cet événement est complet" }, status: :unprocessable_entity }
        end
        return
      end

      registration = @event.event_registrations.build(user: current_user)
      if registration.save
        @event.reload
        respond_to do |format|
          format.html { redirect_to events_path, notice: "Inscription confirmée !" }
          format.json { render json: {
            success: true,
            message: "Inscription confirmée !",
            participants_count: @event.participants.size,
            participants_names: @event.participants.map { |p| p.name.presence || p.email }.join(', ')
          } }
        end
      else
        respond_to do |format|
          format.html { redirect_to events_path, alert: registration.errors.full_messages.join(', ') }
          format.json { render json: { success: false, message: registration.errors.full_messages.join(', ') }, status: :unprocessable_entity }
        end
      end
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to events_path, alert: "Événement introuvable" }
      format.json { render json: { success: false, message: "Événement introuvable" }, status: :not_found }
    end
  end

  def unregister
    registration = @event.event_registrations.find_by(user: current_user)
    if registration&.destroy
      @event.reload
      respond_to do |format|
        format.html { redirect_to events_path, notice: "Désinscription confirmée" }
        format.json { render json: {
          success: true,
          message: "Désinscription confirmée",
          participants_count: @event.participants.size,
          participants_names: @event.participants.map { |p| p.name.presence || p.email }.join(', ')
        } }
      end
    else
      respond_to do |format|
        format.html { redirect_to events_path, alert: "Vous n'êtes pas inscrit à cet événement" }
        format.json { render json: { success: false, message: "Vous n'êtes pas inscrit à cet événement" }, status: :unprocessable_entity }
      end
    end
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
    params.require(:event).permit(:name, :date, :place, :description, :category, :max_participations, :address, :latitude, :longitude)
  end
end
