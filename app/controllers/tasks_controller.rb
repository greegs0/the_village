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
    redirect_to family_tasks_path(@family)
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
end
