require 'rails_helper'

RSpec.describe Subscription, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:team) }
  it { should define_enum_for(:status).with(%i[awaiting approved rejected]) }
end
