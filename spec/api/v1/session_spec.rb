require 'rails_helper'
require_relative 'api_helper'

describe 'Profile API' do
  describe 'POST create' do
    let(:url) { '/api/v1/sign-in' }

    context 'get access token' do
      include_context 'users'
      before do
        post_request(api_v1_sign_in_path, user_login: { email: user.email, password: user.password })
      end

      it do
        user.reload
        expect(response.body).to be_json_eql(user.auth_token.to_json).at_path('auth_token')
      end
    end
  end
end
