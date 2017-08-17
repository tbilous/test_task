require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:teams).dependent(:destroy) }
  it { should have_many(:collaborators).dependent(:destroy) }
  it { should have_many(:teams_collaborator).through(:collaborators).source(:user) }
  it do
    should have_many(:teams__accepted_collaborator).through(:collaborators).source(:user)
                                                   .conditions(collaborators: { status: 'accepted' })
  end
  it do
    should have_many(:teams__awaiting_collaborator).conditions(collaborators: { status: 'awaiting' })
      .through(:collaborators).source(:user)
  end

  describe '#owner_of?' do
    let(:author) { create(:user) }
    let(:stranger) { create(:user) }
    let(:team) { create(:team, user: author) }

    context 'when user is the owner of team' do
      it { expect(author).to be_owner_of(team) }
    end
    context 'when user is not the team`s owner' do
      it { expect(stranger).to_not be_owner_of(team) }
    end
  end

  describe '#his_name' do
    let(:user) { create(:user, email: 'test@test.com') }

    it { expect(user.his_name_is).to eq('test') }
  end
end
