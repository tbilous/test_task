require 'rails_helper'
require 'acceptance_helper'

feature 'I can to manage teams', %q{
  As a team owner
  I want to add/edit/assign/assign task in my team
  As a collaborator
  I want see my tasks
  I want change task`s status
} do

  include_context 'users'

  let(:users) { create_list(:user, 10) }

  let(:team) { create(:team, user_id: user.id) }
  let!(:collaborating) do
    create(:collaborator, user_id: users.first.id, team_id: team.id, status: 'approved')
  end
  let!(:collaborating2) do
    create(:collaborator, user_id: users[2].id, team_id: team.id, status: 'approved')
  end

  context 'as a team owner' do
    background do
      login_as(user)
    end
    let(:task) { attributes_for(:task) }
    scenario 'I want to add/edit/assign/assign task', :js, :feature do
      visit authenticated_root_path
      click_on team.title
      click_on t('task.add')

      fill_in 'task_title', with: task[:title]
      fill_in 'task_body', with: task[:body]
      select users.first.email, from: 'task_user_id'
      select t('activerecord.attributes.task.type.bug_fix'), from: 'task_task_type'

      within '#new_task' do
        click_on t('save')
      end

      within '#teamTasks' do
        expect(page).to have_content task[:title]
        expect(page).to have_content users.first.his_name_is
        expect(page).to have_content t('task.assign')
      end

      within '#teamTasks' do
        click_on t('task.edit')
      end

      fill_in 'task_title', with: '123'
      fill_in 'task_body', with: '123'
      select users[2].email, from: 'task_user_id'
      select t('activerecord.attributes.task.type.test'), from: 'task_task_type'
      click_on t('save')

      within '#teamTasks' do
        expect(page).to have_content '123'
        expect(page).to have_content users[2].his_name_is
        expect(page).to have_content t('task.assign')
      end

      within "#userTask#{Task.last.id}" do
        click_on t('task.assign')
        wait_animation
        expect(page).to have_content t('activerecord.attributes.task.state.assigned')
      end

      within "#userTask#{Task.last.id}" do
        find('.btn-danger').trigger('click')
      end

      wait_animation
      click_on  t('a_yes')
      wait_animation

      within '#teamTasks' do
        expect(page).to_not have_content '123'
        expect(page).to_not have_content users[2].his_name_is
        expect(page).to_not have_content t('activerecord.attributes.task.state.open')
      end
    end
  end

  context 'as a collaborator' do
    let!(:task) { create(:task, team_id: team.id, user_id: users.first.id, state: :assigned) }

    background do
      login_as(users.first)
      visit authenticated_root_path
    end

    scenario 'I want see my tasks', :feature do
      expect(page).to have_content(task.title)
      expect(page).to have_content t('activerecord.attributes.task.state.assigned')
    end

    scenario 'I want change task`s status' do
      click_on(task.title)
      expect(page).to have_content(task.body)
      click_on t('task.actions.in_progress')
      wait_animation
      within '.label' do
        expect(page).to have_content t('activerecord.attributes.task.state.in_progress')
      end
    end
  end
end
