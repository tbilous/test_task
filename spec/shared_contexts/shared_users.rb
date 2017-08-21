shared_context 'users', users: true do
  let(:user) { create(:user) }
  let(:non_owner) { create(:user) }
end
