require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  include_context 'users'

  describe 'GET #index' do
    it_behaves_like 'when user is authorized' do
      it 'returns http success' do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
  end
end
