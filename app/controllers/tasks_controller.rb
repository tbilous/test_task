class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :load_team, only: %i[create new]
  # before_action :load_user, only: %i[create]
  before_action :load_task, only: %i[destroy update edit show]

  respond_to :js, only: %i[destroy set_state]
  respond_to :json, only: :set_state

  def create
    @task = @team.tasks.create(strong_params)
    respond_with(@task, location: team_path(@team.id))
  end

  def update
    @task.update(strong_params)
    respond_with(@task, location: team_path(@task.team.id))
  end

  def destroy
    respond_with(@task.destroy)
  end

  def new
    @task = Task.new
    respond_with(@task)
  end

  def edit
    @team = @task.team
  end

  def show; end

  def set_state
    @task = Task.find(params[:task_id])
    case params[:state]
    when 'assigned' then
      @task.update(state: :assigned)
    when 'in_progress' then
      @task.progress
    when 'done' then
      @task.close
    when 'restart' then
      @task.update(state: :assigned)
    else
      flash[:alert] = t('task.unknown_state')
    end
    respond_with(@task)
  end

  private

  def strong_params
    params.require(:task).permit(:title, :body, :task_type, :user_id)
  end

  def load_team
    @team = Team.find(params[:team_id])
  end

  def load_task
    @task = Task.find(params[:id])
  end

  def load_user
    @user = User.find(params[:user_id])
  end
end
