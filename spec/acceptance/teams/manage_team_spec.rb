require 'rails_helper'
require 'acceptance_helper'

feature 'I cant to manage teams', %q{
  As a user
  I want to add team and delete him
  I want to add team members
  I took new invite to team
  I want to add task to my team and assign collaborator
} do

  include_context 'users'

  background do
    login_as(user)
  end

  context 'as user' do
    let!(:users) { create_list(:user, 10) }
    scenario 'I want to add team and delete him', :js, :feature do
      visit authenticated_root_path
      find('.fa-group').trigger('click')
      click_link(t('team.index'))
      click_link(visible: true, text: t('team.add'))

      within '#new_team' do
        fill_in 'team_title', with: 'My Awesome Team'
        click_on t('team.add')
      end

      expect(current_path).to eq team_path(Team.last.id)
      within 'h1' do
        expect(page).to have_content 'My Awesome Team'
      end

      visit teams_path
      within "#myOwnedTeam#{Team.last.id}" do
        find('.btn-danger').trigger('click')
      end
      sleep 1
      click_on t('a_no')
      sleep 1
      expect(page).to have_content 'My Awesome Team'

      within "#myOwnedTeam#{Team.last.id}" do
        find('.btn-danger').trigger('click')
      end
      sleep 1
      click_on t('a_yes')
      sleep 1
      expect(page).to_not have_content 'My Awesome Team'
    end
    scenario 'I want to add team members', :js, :feature do
      visit teams_path

      visit authenticated_root_path
      find('.fa-group').trigger('click')
      click_link(t('team.index'))
      click_link(visible: true, text: t('team.add'))

      within '#new_team' do
        fill_in 'team_title', with: 'My Awesome Team'
        click_on t('team.add')
      end

      click_link(t('collaborator.add'))

      expect(current_path).to eq new_team_collaborator_path(Team.last.id)

      fill_in_autocomplete('#users', users[1].email.split('@')[0], users[1].id, 'collaborator_user_id')

      find('.sent-form').trigger('click')

      sleep 2

      within '#awaitingTeamMembers' do
        expect(page).to have_content users[1].email.split('@')[0]
      end
    end

    describe 'took invites', :feature do
      let(:team_owner) { create(:user) }
      let(:team) { create(:team, user_id: team_owner.id) }
      let(:collaborator) { create(:collaborator, team_id: team.id, user_id: user.id) }

      scenario 'I took new invite to team', :js, :feature do
        visit authenticated_root_path
        within '#awaitingCollTeams' do
          expect(page).to_not have_content team.title
        end
      end
    end

    describe 'I want to add task to my team and assign collaborator', :feature do
      let!(:team) { create(:team, user_id: user.id) }
      let!(:collaborating) { create(:collaborator, user_id: users.first.id, team_id: team.id) }
      before { collaborating.update!(status: 'approved') }
      let(:task) { attributes_for(:task) }

      scenario 'I want to add task to my team' do
        visit authenticated_root_path
        click_on team.title
        click_on t('task.add')

        fill_in 'task_title', with: task[:title]
        fill_in 'task_body', with: task[:body]
        select users.first.email, from: 'task_user_id'
        select t('activerecord.attributes.task.type.bug_fix'), from: 'task_task_type'

        within '#new_task' do
          click_on t('task.add')
        end

        within '#teamTasks' do
          expect(page).to have_content task[:title]
          expect(page).to have_content users.first.his_name_is
          expect(page).to have_content t('activerecord.attributes.task.status.open')
        end
      end
    end
  end
end
