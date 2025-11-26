class TasksController < ApplicationController
  before_action :set_family
  before_action :set_task, only: [:show, :edit, :update, :toggle_status, :destroy]

  # GET /families/:family_id/tasks
  def index
    @tasks = @family.tasks.order(created_at: :desc)
    @people = @family.people

    # Calculer les statistiques par personne
    @tasks_by_person = @people.map do |person|
      person_tasks = @tasks.where(assignee_id: person.id)
      completed_tasks = person_tasks.where(status: true).count
      {
        person: person,
        total_tasks: person_tasks.count,
        completed_tasks: completed_tasks,
        percentage: person_tasks.count > 0 ? (completed_tasks.to_f / person_tasks.count * 100).round : 0
      }
    end
  end

  # GET /tasks/:id
  def show
  end

  # GET /families/:family_id/tasks/:id/edit
  def edit
  end

  # GET /families/:family_id/tasks/new
  def new
    @task = @family.tasks.new
  end

  # POST /families/:family_id/tasks
  def create
    @task = @family.tasks.new(task_params)

    if @task.save
      redirect_to family_tasks_path(@family), notice: 'Tâche créée avec succès.'
    else
      @tasks = @family.tasks
      render :index, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /families/:family_id/tasks/:id
  def update
    if @task.update(task_params)
      redirect_to family_task_path(@family, @task), notice: 'Tâche modifiée avec succès.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  # PATCH /families/:family_id/tasks/:id/toggle_status
  def toggle_status
    @task.update(status: !@task.status)

    respond_to do |format|
      format.html { redirect_to family_tasks_path(@family) }
      format.turbo_stream {
        # Reload sidebar data for updated counts
        load_sidebar_data
        render turbo_stream: turbo_stream.replace(
          "sidebar-today-widget",
          partial: "shared/sidebar_today_widget",
          locals: {
            sidebar_today_tasks: @sidebar_today_tasks,
            sidebar_today_events: @sidebar_today_events
          }
        )
      }
    end
  end

  # DELETE /families/:family_id/tasks/:id
  def destroy
    @task.destroy
    redirect_to family_tasks_path(@family), notice: "Tâche supprimée avec succès."
  end

  private

  def set_family
    @family = Family.find(params[:family_id])
  end

  def set_task
    @task = @family.tasks.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :target_date, :user_id, :assignee_id, :description)
  end

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

    # Events data - Only show events that START today
    @sidebar_today_events = family.family_events
                                  .where('start_date = ?', today)
                                  .order(time: :asc)
                                  .limit(3)
    @sidebar_today_events_count = @sidebar_today_events.count
  end
end
