class FamiliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family, except: [:new, :create]
  before_action :authorize_member!, only: [:edit, :update, :destroy, :regenerate_invitation_code]

  def show
    # @people = @family.people.order(birthday: :desc)                    # du plus jeune au plus vieux
    # @tasks  = @family.tasks.order(created_at: :desc).limit(10)          # limite 10 tâches pour pas polluer le dashboard
    # @events = @family.family_events.order(start_date: :asc).limit(5)
    # @files  = @family.files.order(created_at: :desc).limit(10)
  end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)
    if @family.save
      current_user.update!(family: @family)
      redirect_to family_path, notice: "Famille créée."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @family.update(family_params)
      redirect_to family_path, notice: "Famille mise à jour."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def regenerate_invitation_code
    @family.regenerate_invitation_code
    redirect_to edit_family_path, notice: "Nouveau code d'invitation généré."
  end

  def destroy
    @family.destroy
    sign_out current_user
    redirect_to root_path, notice: "Famille supprimée."
  end

  private

  def set_family
    @family = current_user.family

    # Un member doit avoir une famille
    if current_user.member? && @family.nil?
      redirect_to new_family_path, alert: "Crée d'abord ta famille."
    end
    # helper :
    # - avec family -> OK, voit le dashboard
    # - sans family -> cas non géré en V1 (code d'invitation)
  end

  def authorize_member!
    return if current_user.member?

    redirect_to family_path, alert: "Vous n'avez pas les droits pour modifier la famille."
  end

  def family_params
    params.require(:family).permit(:name, :zipcode)
  end
end
