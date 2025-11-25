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
  def family_context
    family = current_user.family
    return nil unless family

    # Récupérer les informations des membres
    members_info = family.people.map do |person|
      info = person.name
      info += " (#{person.age} ans)" if person.age
      info
    end.join(", ")

    # Récupérer les zipcodes uniques
    zipcodes = family.people.pluck(:zipcode).compact.uniq.join(", ")

    {
      name: family.name,
      members_count: family.people.count,
      members_info: members_info,
      zipcodes: zipcodes.presence || "Non renseigné",
      tasks_count: family.tasks.where(status: false).count,
      events_count: family.family_events.where('start_date >= ?', Date.today).count
    }
  end
end
