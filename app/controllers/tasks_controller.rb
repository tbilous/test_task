class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :load_team, only: %i[create]
  before_action :load_user, only: %i[create]
  before_action :load_task, only: %i[destroy update]

  respond_to :json, only: %i[destroy update]

  def create
    @task = @team.tasks.create(strong_params.merge(user_id: params[:user_id]))
    respond_with(@task)
  end

  def update
    @task.update(strong_params)
    respond_with(@task)
  end

  def destroy
    respond_with(@task.destroy)
  end

  def new
    @task = Task.new
    respond_with(@task)
  end

  private

  def strong_params
    params.require(:task).permit(:title, :body, :status, :task_type, :user_id)
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