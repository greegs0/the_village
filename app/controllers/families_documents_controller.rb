class FamiliesDocumentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family

  def show
    # @documents = @family.documents.order(created_at: :desc) if @family
    # Pour l'instant, on affiche juste la vue statique
  end

  private

  def set_family
    @family = current_user.family

    if @family.nil?
      if current_user.member?
        redirect_to new_family_path, alert: "Crée d'abord ta famille."
      else
        redirect_to root_path, alert: "Vous devez être associé à une famille."
      end
    end
  end
end
