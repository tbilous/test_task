class CollaboratorsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_collaborator, only: %i[destroy update]
  before_action :load_team, only: %i[create]
  before_action :load_user, only: %i[create]

  respond_to :json

  def create
    @collaborator = @team.collaborators.create(strong_params)
    respond_with(@collaborator)
  end

  def update
    @collaborator.update(status: strong_params[:status])
    respond_with(@collaborator)
  end

  def destroy
    respond_with(@collaborator.destroy)
  end

  private

  def strong_params
    params.permit(:team_id, :user_id, :status)
  end

  def load_team
    @team = Team.find(params[:team_id])
  end

  def load_user
    @user = User.find(params[:user_id])
  end

  def load_collaborator
    @collaborator = Collaborator.find(params[:id])
  end
end
