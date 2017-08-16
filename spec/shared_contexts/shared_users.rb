shared_context 'users', users: true do
  let(:user) { create(:user) }
  # let(:admin) { create(:user, admin: true) }
end
