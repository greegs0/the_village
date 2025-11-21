class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update, :toggle_status]

  # GET /tasks
  def index
    @tasks = Task.all
    @people = Person.all

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

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # POST /tasks
  def create
    @task = Task.new(task_params)

    if @task.save
      redirect_to tasks_path, notice: 'Task was successfully created.'
    else
      @tasks = Task.all
      render :index, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/:id
  def update
    if @task.update(task_params)
      redirect_to task_path(@task), notice: 'Task was successfully updated.'
    else
      render :show, status: :unprocessable_entity
    end
  end

  # PATCH /tasks/:id/toggle_status
  def toggle_status
    @task.update(status: !@task.status)
    redirect_to tasks_path, notice: "Statut de la tâche mis à jour."
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :target_date, :user_id, :assignee_id)
  end
end
