class TasksController < ApplicationController
  before_action :set_task, only: [:show, :update]

  # GET /tasks
  def index
    @tasks = Task.all
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

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :target_date, :user_id, :assignee_id)
  end
end
