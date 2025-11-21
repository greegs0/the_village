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
end
