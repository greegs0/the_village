class FamiliesCalendarsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family
  before_action :set_family_event, only: [:edit_event, :update_event, :destroy_event]
  before_action :set_unavailability, only: [:edit_unavailability, :update_unavailability, :destroy_unavailability]
  before_action :authorize_member!, only: [:new_event, :create_event, :edit_event, :update_event, :destroy_event,
                                           :new_unavailability, :create_unavailability, :edit_unavailability,
                                           :update_unavailability, :destroy_unavailability]

  def show
    @family_events = @family.family_events.order(start_date: :asc)
    @unavailabilities = @family.unavailabilities.includes(:user).order(start_date: :asc)
  end

  # Family Events actions
  def new_event
    @family_event = @family.family_events.build
  end

  def create_event
    @family_event = @family.family_events.build(family_event_params)
    if @family_event.save
      redirect_to families_calendar_path, notice: "Événement créé."
    else
      render :new_event, status: :unprocessable_entity
    end
  end

  def edit_event; end

  def update_event
    if @family_event.update(family_event_params)
      redirect_to families_calendar_path, notice: "Événement mis à jour."
    else
      render :edit_event, status: :unprocessable_entity
    end
  end

  def destroy_event
    @family_event.destroy
    redirect_to families_calendar_path, notice: "Événement supprimé."
  end

  # Unavailabilities actions
  def new_unavailability
    @unavailability = @family.unavailabilities.build(user: current_user)
  end

  def create_unavailability
    @unavailability = @family.unavailabilities.build(unavailability_params)
    @unavailability.user = current_user
    if @unavailability.save
      redirect_to families_calendar_path, notice: "Indisponibilité créée."
    else
      render :new_unavailability, status: :unprocessable_entity
    end
  end

  def edit_unavailability; end

  def update_unavailability
    if @unavailability.update(unavailability_params)
      redirect_to families_calendar_path, notice: "Indisponibilité mise à jour."
    else
      render :edit_unavailability, status: :unprocessable_entity
    end
  end

  def destroy_unavailability
    @unavailability.destroy
    redirect_to families_calendar_path, notice: "Indisponibilité supprimée."
  end

  private

  def set_family
    @family = current_user.family

    if current_user.member? && @family.nil?
      redirect_to new_family_path, alert: "Crée d'abord ta famille."
    end
  end

  def set_family_event
    @family_event = @family.family_events.find(params[:id])
  end

  def set_unavailability
    @unavailability = @family.unavailabilities.find(params[:id])
  end

  def authorize_member!
    return if current_user.member?

    redirect_to families_calendar_path, alert: "Vous n'avez pas les droits pour cette action."
  end

  def family_event_params
    params.require(:family_event).permit(:title, :event_type, :description, :location,
                                         :start_date, :end_date, :assigned_to, :enable_reminders)
  end

  def unavailability_params
    params.require(:unavailability).permit(:start_date, :end_date, :reason)
  end
end
