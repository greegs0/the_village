class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  # Redirect to families page after sign in
  def after_sign_in_path_for(resource)
    families_path
  end

  # Redirect to families page after sign up
  def after_sign_up_path_for(resource)
    families_path
  end
end
