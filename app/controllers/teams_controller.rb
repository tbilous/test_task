class TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_team, only: %i[edit destroy update]

  respond_to :js, only: %i[update destroy]

  def create
    @team = current_user.teams.create(strong_params)
    respond_with(@team)
  end

  def update
    @team.update(strong_params)
    respond_with(@team)
  end

  def destroy
    respond_with(@team.destroy)
  end

  def new
    @team = current_user.teams.new
  end

  def show; end

  def edit; end

  def index
    @teams = current_user.teams
  end

  private

  def strong_params
    params.require(:team).permit(:title)
  end

  def load_team
    @team = Team.find(params[:id])
  end
end
