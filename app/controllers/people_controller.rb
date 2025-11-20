class PeopleController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family
  before_action :authorize_member!
  before_action :set_person, only: [:edit, :update, :destroy]

  def new
    @person = Person.new(family: @family) # Anciennement @person = @family.people.new -> crée un fantôme
  end

  def create
    @person = @family.people.new(person_params)
    if @person.save
      if params[:force_modal] == "true"
        redirect_to family_path, notice: "Bienvenue ! Votre famille est prête."
      else
        @family.people.reload  # GHOSTBUSTER 👻🔫 Supprime tous les fantômes non sauvegardés !
        redirect_to new_person_path, notice: "Membre ajouté à la famille."
      end
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @person.update(person_params)
      redirect_to families_path, notice: "Membre mis à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @person.destroy
    redirect_to families_path, notice: "Membre supprimé."
  end

  private

  def set_family
    @family = current_user.family
  end

  def set_person
    @person = @family.people.find(params[:id])
  end

  def person_params
    params.require(:person).permit(:name, :birthday, :zipcode)
  end

  def authorize_member!
    return if current_user.member?
    redirect_to families_path, alert: "Vous n'avez pas les droits pour modifier les membres."
  end
end
