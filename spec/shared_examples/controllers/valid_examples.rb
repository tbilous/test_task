# shared_examples 'when user is authorized' do
#   include_context 'authorized user is admin'
# end
shared_examples 'when user is authorized' do
  include_context 'authorized user'
end
shared_examples 'when user is owner' do
  include_context 'authorized user'
end
