class FamilyEventsController < ApplicationController
  before_action :set_family
  before_action :set_family_members
  before_action :set_family_event, only: [:update, :destroy]

  def index
    @current_date = params[:date] ? Date.parse(params[:date]) : Date.today
    @family_events = @family.family_events.for_month(@current_date)
    @family_event = FamilyEvent.new # Pour le formulaire de création

    # Charger les événements des 7 prochains jours
    @upcoming_events = @family.family_events
                              .where("start_date >= ?", Date.today)
                              .where("start_date <= ?", Date.today + 7.days)
                              .order(start_date: :asc, time: :asc)
                              .limit(5)

    # Generate calendar data
    @calendar_start = @current_date.beginning_of_month.beginning_of_week(:monday)
    @calendar_end = @current_date.end_of_month.end_of_week(:monday)
    @calendar_weeks = []

    current = @calendar_start
    while current <= @calendar_end
      week = []
      7.times do
        week << current
        current = current.next_day
      end
      @calendar_weeks << week
    end

    # Charger les tâches par jour pour le mois affiché
    @tasks_by_date = @family.tasks
                           .where(status: [false, nil])
                           .where(target_date: @calendar_start..@calendar_end)
                           .group(:target_date)
                           .count
  end

  def create
    @family_event = @family.family_events.new(family_event_params)

    if @family_event.save
      respond_to do |format|
        format.html { redirect_to family_family_events_path(@family), notice: 'Événement créé avec succès.' }
        format.json { render json: @family_event, status: :created }
      end
    else
      respond_to do |format|
        format.html { redirect_to family_family_events_path(@family), alert: @family_event.errors.full_messages.join(', ') }
        format.json { render json: @family_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @family_event.update(family_event_params)
      respond_to do |format|
        format.html { redirect_to family_family_events_path(@family), notice: 'Événement modifié avec succès.' }
        format.json { render json: @family_event }
      end
    else
      respond_to do |format|
        format.html { redirect_to family_family_events_path(@family), alert: @family_event.errors.full_messages.join(', ') }
        format.json { render json: @family_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @family_event.destroy
    respond_to do |format|
      format.html { redirect_to family_family_events_path(@family), notice: 'Événement supprimé avec succès.' }
      format.json { head :no_content }
    end
  end

  private

  def set_family
    @family = Family.find(params[:family_id])
  end

  def set_family_members
    @family_members = @family.people
  end

  def set_family_event
    @family_event = @family.family_events.find(params[:id])
  end

  def family_event_params
    params.require(:family_event).permit(
      :title,
      :event_type,
      :description,
      :start_date,
      :end_date,
      :time,
      :location,
      :address,
      :latitude,
      :longitude,
      :assigned_to,
      :reminders_enabled
    )
  end
end
