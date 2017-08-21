require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:team) }
  it { should define_enum_for(:state).with(%i[open assigned in_progress done]) }
  it { should define_enum_for(:task_type).with(%i[bug_fix code test]) }

  let(:author) { create(:user) }
  let(:user) { create(:user) }
  let(:team) { create(:team, user_id: author.id) }
  let(:collaborator) { create(:collaborator, user_id: user.id, team_id: team.id) }

  describe ':ready' do
    let(:task1) { create(:task, user_id: user.id, team_id: team.id, state: :open) }
    let(:task2) { create(:task, user_id: user.id, team_id: team.id, state: :done) }
    let(:task3) { create(:task, user_id: user.id, team_id: team.id, state: :in_progress) }
    let(:task4) { create(:task, user_id: user.id, team_id: team.id, state: :assigned) }
    let(:task5) { create(:task, user_id: user.id, team_id: team.id, state: :assigned) }

    it { expect(Task.ready).to include(task3, task4, task5) }
  end

  describe '#next_role' do
    let(:task) { create(:task, user_id: user.id, team_id: team.id, state: :open) }
    it { expect(task.next_role).to eq('assigned') }
  end
end
