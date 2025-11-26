class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_sidebar_data, unless: :devise_controller?

  # Redirect to families page after sign in
  def after_sign_in_path_for(resource)
    if resource.family.present?
      family_path(resource.family)
    else
      new_family_path
    end
  end

  # Redirect to families page after sign up
  def after_sign_up_path_for(resource)
    new_family_path
  end

  private

  # Load sidebar data for all authenticated pages
  def load_sidebar_data
    return unless current_user&.family

    family = current_user.family
    today = Date.today

    # Tasks data - Only count incomplete tasks (in progress)
    # Handle NULL status as incomplete (false)
    @sidebar_pending_tasks_count = family.tasks.where('status = ? OR status IS NULL', false).count
    @sidebar_today_tasks = family.tasks
                                  .where('target_date = ?', today)
                                  .where('status = ? OR status IS NULL', false)
                                  .order(created_at: :desc)
                                  .limit(5)

    # Events data - Include events that start today OR are ongoing today
    # Handle NULL end_date (single-day events)
    @sidebar_today_events = family.family_events
                                  .where('start_date <= ? AND (end_date >= ? OR end_date IS NULL)', today, today)
                                  .order(time: :asc, start_date: :asc)
                                  .limit(3)
    @sidebar_today_events_count = @sidebar_today_events.count
  end

  protected

  def configure_permitted_parameters
    # Autorise name et zipcode lors de l'inscription
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :zipcode, :birthday])
    # Autorise aussi pour la mise à jour du profil
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :zipcode, :birthday])
  end

  # Méthode partagée pour récupérer le contexte de la famille (DRY)
  def family_context
    family = current_user.family
    return nil unless family

    # Récupérer les informations des membres avec dates d'anniversaire
    members_info = family.people.map do |person|
      info = person.name
      info += " (#{person.age} ans)" if person.age
      info += " - anniversaire: #{I18n.l(person.birthday, format: :long)}" if person.birthday
      info
    end.join(", ")

    # Récupérer les zipcodes uniques
    zipcodes = family.people.pluck(:zipcode).compact.uniq.join(", ")

    # Récupérer les événements locaux à venir (suggestions d'activités)
    local_events = Event.where('date >= ?', Date.today)
                        .order(:date)
                        .limit(10)
                        .map do |event|
      "#{event.name} (#{I18n.l(event.date, format: :short)}) - #{event.place} [#{event.category}]"
    end.join(", ")

    # Récupérer la répartition des tâches par membre
    tasks_distribution = family.people.map do |person|
      tasks_count = family.tasks.where(assignee_id: person.id).where('status = ? OR status IS NULL', false).count
      "#{person.name}: #{tasks_count} tâche(s)"
    end.join(", ")

    {
      name: family.name,
      members_count: family.people.count,
      members_info: members_info,
      zipcodes: zipcodes.presence || "Non renseigné",
      tasks_count: family.tasks.where('status = ? OR status IS NULL', false).count,
      tasks_distribution: tasks_distribution,
      events_count: family.family_events.where('start_date >= ?', Date.today).count,
      local_events: local_events.presence || "Aucun événement local disponible"
    }
  end
end
