require 'rails_helper'
require 'acceptance_helper'

feature 'I can to manage teams', %q{
  As a team owner
  I want to add/edit task in my team and assign collaborator
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
  let(:task) { attributes_for(:task) }

  context 'as a team owner' do
    background do
      login_as(user)
    end


    scenario 'I want to add/edit/destroy task' do
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
        expect(page).to have_content t('activerecord.attributes.task.status.open')
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
        expect(page).to have_content t('activerecord.attributes.task.status.open')
      end
    end
  end

  context 'as a team owner' do
    background do
      login_as(users.first)
    end

    scenario 'I want see my tasks' do

    end

    scenario 'I want change task`s status' do

    end
  end
end
