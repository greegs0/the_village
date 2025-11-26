class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

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

  protected

  def configure_permitted_parameters
    # Autorise name et zipcode lors de l'inscription
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :zipcode, :birthday])
    # Autorise aussi pour la mise à jour du profil
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :zipcode, :birthday])
  end

  # Méthode partagée pour récupérer le contexte de la famille (DRY)
  # Optimisée pour éviter les N+1 queries
  def family_context
    family = current_user.family
    return nil unless family

    # Charger les personnes une seule fois
    people = family.people.to_a

    # Récupérer les informations des membres avec dates d'anniversaire
    members_info = people.map do |person|
      info = person.name
      info += " (#{person.age} ans)" if person.respond_to?(:age) && person.age
      info += " - anniversaire: #{I18n.l(person.birthday, format: :long)}" if person.birthday
      info
    end.join(", ")

    # Récupérer les zipcodes uniques (utilise les données déjà chargées)
    zipcodes = people.map(&:zipcode).compact.uniq.join(", ")

    # Récupérer les événements locaux à venir (une seule requête)
    local_events = Event.where('date >= ?', Date.today)
                        .order(:date)
                        .limit(10)
                        .pluck(:name, :date, :place, :category)
                        .map { |name, date, place, category| "#{name} (#{I18n.l(date, format: :short)}) - #{place} [#{category}]" }
                        .join(", ")

    # Récupérer les stats de tâches en une seule requête groupée
    tasks_by_assignee = family.tasks.where(status: false).group(:assignee_id).count
    tasks_distribution = people.map do |person|
      count = tasks_by_assignee[person.id] || 0
      "#{person.name}: #{count} tâche(s)"
    end.join(", ")

    {
      name: family.name,
      members_count: people.size,
      members_info: members_info,
      zipcodes: zipcodes.presence || "Non renseigné",
      tasks_count: tasks_by_assignee.values.sum,
      tasks_distribution: tasks_distribution,
      events_count: family.family_events.where('start_date >= ?', Date.today).count,
      local_events: local_events.presence || "Aucun événement local disponible"
    }
  end
end
