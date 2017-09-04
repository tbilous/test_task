require 'rails_helper'
require_relative 'api_helper'

describe 'Profile API' do
  describe 'POST registrations/create' do
    let(:url) { '/api/v1/registrations' }

    context 'registration' do
      let(:user) { attributes_for(:user) }
      let(:registered) { create(:user) }
      context 'user had registered' do
        before do
          post_request(url, user_registration: { email: registered.email, password: registered.password })
        end

        it do
          expect(response.body).to include_json({ detail: 'Wrong registration params' }.to_json)
            .at_path('errors')
        end
      end
      context 'user is new' do
        before do
          post_request(url, user_registration: { email: user[:email], password: user[:password] })
        end
        it do
          expect(response.body).to be_json_eql(User.find_by_email(user[:email]).auth_token.to_json)
            .at_path('auth_token')
          expect(response.body).to be_json_eql(User.find_by_email(user[:email]).id.to_json)
            .at_path('user')
        end
      end
    end
  end

  describe 'POST token/create' do
    let(:url) { '/api/v1/sign-in' }

    context 'get access token' do
      include_context 'users'
      before do
        post_request(url, user_login: { email: user.email, password: user.password })
      end

      it do
        user.reload
        expect(response.body).to be_json_eql(user.auth_token.to_json).at_path('auth_token')
      end
    end
  end
end
