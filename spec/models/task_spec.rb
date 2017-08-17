require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:team) }
  it { should define_enum_for(:state).with(%i[open assigned in_progress done]) }
  it { should define_enum_for(:task_type).with(%i[bug_fix code test]) }
end
