shared_context 'authorized user', auth: true do
  before { sign_in(user) }
end

shared_context 'unauthorized user', unauth: true do
  before { sign_out(user) }
end
#
# shared_context 'authorized user is admin', auth: true do
#   include_context 'users'
#   before { sign_in(admin) }
# end
