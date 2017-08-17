require 'rails_helper'

RSpec.describe Team, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:collaborators).dependent(:destroy) }

  it { should validate_presence_of :title }
end
