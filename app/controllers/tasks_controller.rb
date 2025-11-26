class TasksController < ApplicationController
  before_action :set_family
  before_action :set_task, only: [:show, :edit, :update, :toggle_status, :destroy]

  # GET /families/:family_id/tasks
  def index
    @tasks = @family.tasks.includes(:assignee)
    @people = @family.people

    # Filtrage par date si paramètre présent (depuis le calendrier)
    @filter_date = params[:date].present? ? Date.parse(params[:date]) : nil
    if @filter_date
      @tasks = @tasks.where(target_date: @filter_date)
    end

    # Tri selon le paramètre (défaut: date de création desc)
    @sort = params[:sort] || 'created_at_desc'
    @tasks = case @sort
             when 'date_asc'
               @tasks.order(Arel.sql('CASE WHEN target_date IS NULL THEN 1 ELSE 0 END, target_date ASC'))
             when 'date_desc'
               @tasks.order(Arel.sql('CASE WHEN target_date IS NULL THEN 1 ELSE 0 END, target_date DESC'))
             when 'assignee'
               @tasks.joins('LEFT JOIN people ON people.id = tasks.assignee_id').order(Arel.sql('CASE WHEN people.name IS NULL THEN 1 ELSE 0 END, people.name ASC'))
             when 'created_at_asc'
               @tasks.order(created_at: :asc)
             else # 'created_at_desc'
               @tasks.order(created_at: :desc)
             end

    # Pagination
    @tasks = @tasks.page(params[:page]).per(15)

    # Calculer les statistiques par personne (une seule requête groupée)
    tasks_stats = @family.tasks.group(:assignee_id, :status).count
    @tasks_by_person = @people.map do |person|
      total = (tasks_stats[[person.id, true]] || 0) + (tasks_stats[[person.id, false]] || 0)
      completed = tasks_stats[[person.id, true]] || 0
      {
        person: person,
        total_tasks: total,
        completed_tasks: completed,
        percentage: total > 0 ? (completed.to_f / total * 100).round : 0
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
