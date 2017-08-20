class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    @collaborators = current_user.awaiting_collaborators.includes(:team)
    @approved_teams = Team.where(id: current_user.approved_collaborators.pluck(:team_id))
  end
end
