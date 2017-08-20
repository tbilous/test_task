require 'rails_helper'
require 'acceptance_helper'

feature 'I can to manage teams', %q{
  As a team collaborator
  I took new invite to team
  I want to accept invite
  I want to reject invite
  I took task
  I want to start task
} do

  include_context 'users'
  let(:team_owner) { create(:user) }
  let(:team) { create(:team, user_id: team_owner.id) }
  let!(:collaborator) { create(:collaborator, team_id: team.id, user_id: user.id) }
  let!(:tasks) { create_list(:task, 2, team_id: team.id, user_id: user.id) }

  background do
    login_as(user)
    visit authenticated_root_path
  end

  context 'as collaborator' do
    describe 'took invite' do
      scenario 'I accept new invite to team', :js, :feature do
        within '#awaitingCollTeams' do
          expect(page).to have_content team.title
          find("#approve#{collaborator.id}").trigger('click')
          wait_animation
        end
        within '#userCollTeams' do
          expect(page).to have_content team.title
        end
      end

      scenario 'I reject new invite to team', :js, :feature do
        within '#awaitingCollTeams' do
          expect(page).to have_content team.title
          find("#reject#{collaborator.id}").trigger('click')
          expect(page).to_not have_content team.title
          wait_animation
        end
        within '#userCollTeams' do
          expect(page).to_not have_content team.title
        end
      end
    end

    describe 'took task' do
      before { collaborator.update!(status: 'approved') }

      scenario 'I reject new invite to team', :js, :feature do
        within "#task#{tasks.first.id}" do
          expect(page).to have_content tasks.first.title
          expect(page).to have_content t("activerecord.attributes.task.status.#{tasks.first.state}")
          wait_animation
        end
      end
    end
  end
end
