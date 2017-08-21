class CollaboratorsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_collaborator, only: %i[destroy update]
  before_action :load_team, only: %i[create new staff]
  before_action :load_user, only: %i[create]

  before_action :check_pm_access, only: %i[create new staff]
  before_action :check_col_access, only: %i[update]
  before_action :check_pm_through_access, only: %i[destroy]

  respond_to :json, only: %i[create update destroy staff]
  respond_to :html, only: :new

  def create
    @collaborator = @team.collaborators.create(strong_params)
    respond_with(@collaborator)
  end

  def update
    @collaborator.update(update_params)
    render json: @collaborator
  end

  def destroy
    respond_with(@collaborator.destroy)
  end

  def new
    @collaborators = @team.team_users
  end

  def staff
    @users = User.not_in_team(@team, @team.user_id).select_search(params[:q])
    respond_with @users
  end

  private

  def strong_params
    params.require(:collaborator).permit(:team_id, :user_id, :status)
  end

  def update_params
    params.permit(:status)
  end

  def load_team
    @team = Team.find(params[:team_id])
  end

  def load_user
    @user = User.find(params[:collaborator][:user_id])
  end

  def load_collaborator
    @collaborator = Collaborator.find(params[:id])
  end

  def check_pm_access
    redirect_to authenticated_root_path unless current_user.owner_of?(@team)
  end

  def check_pm_through_access
    redirect_to authenticated_root_path unless current_user.owner_of?(@collaborator.team)
  end

  def check_col_access
    redirect_to authenticated_root_path unless current_user.owner_of?(@collaborator)
  end
end
