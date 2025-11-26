class FamiliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_family, except: [:new, :create]
  before_action :authorize_member!, only: [:edit, :update, :destroy, :regenerate_invitation_code]

  def show
    @people = @family.people.order(birthday: :desc)                    # du plus jeune au plus vieux
    @tasks  = Task.all # Toutes les tâches pour l'instant
    @events = @family.family_events.where("start_date >= ?", Date.today).order(start_date: :asc, time: :asc).limit(5)
    @documents_count = @family.documents.count

    # Activité récente - Tâches complétées récemment (max 5)
    @recent_completed_tasks = Task.where(status: true)
                                  .order(updated_at: :desc)
                                  .limit(5)

    # Progression des tâches hebdomadaires
    week_start = Date.today.beginning_of_week
    week_end = Date.today.end_of_week
    weekly_tasks = Task.where(target_date: week_start..week_end)

    @weekly_completed = weekly_tasks.where(status: true).count
    @weekly_overdue = weekly_tasks.where(status: [false, nil])
                                  .where("target_date < ?", Date.today)
                                  .count
    @weekly_ongoing = weekly_tasks.where(status: [false, nil])
                                  .where("target_date >= ?", Date.today)
                                  .count
    @weekly_total = weekly_tasks.count
    @weekly_percentage = @weekly_total > 0 ? ((@weekly_completed.to_f / @weekly_total) * 100).round : 0

    # Chats
    @chats = current_user.chats.recent

    # Si un chat_id est passé en paramètre, on l'utilise, sinon on prend le premier
    if params[:chat_id].present?
      @current_chat = current_user.chats.find_by(id: params[:chat_id])
    end

    # Si pas de chat trouvé ou pas de paramètre, on prend le premier ou on en crée un
    @current_chat ||= @chats.first || current_user.chats.create(title: "Nouvelle conversation")

    @messages = @current_chat.messages.chronological
    @message = Message.new
  end

  def new
    @family = Family.new
  end

  def create
    @family = Family.new(family_params)
    if @family.save
      current_user.update!(family: @family, status: "member")
      @family.people.create(
        name: current_user.name,
        zipcode: current_user.zipcode,
        birthday: current_user.birthday
      )
      redirect_to families_path, notice: "Famille créée ! Bienvenue dans the village, n'hésite pas à créer un membre ! 😊"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @family.update(family_params)
      redirect_to families_path, notice: "Famille mise à jour. 🆕"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def regenerate_invitation_code
    @family.regenerate_invitation_code
    redirect_to edit_family_path(@family), notice: "Nouveau code d'invitation généré."
  end

  def destroy
    @family.destroy
    sign_out current_user
    redirect_to root_path, notice: "Famille supprimée."
  end

  private

  def set_family
    @family = current_user.family
    redirect_to new_family_path if @family.nil?

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

    redirect_to families_path, alert: "Vous n'avez pas les droits pour modifier la famille."
  end

  def family_params
    params.require(:family).permit(:name, :zipcode)
  end
end
