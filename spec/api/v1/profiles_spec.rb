require 'rails_helper'
require_relative 'api_helper'

describe 'Profile API' do
  describe 'POST create' do
    let(:url) { '/api/v1/profiles' }
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

  describe 'GET /me' do
    let(:user) { create(:user) }
    let!(:token) { user.generate_auth_token }
    allowed_attributes = %w(id email)

    before do
      get me_api_v1_profiles_path, headers: { 'Authorization' => "Token token=#{token}" }
    end
    allowed_attributes.each do |attr|
      it "returns user #{attr}" do
        expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path(attr)
      end
    end
  end

  describe 'GET /show' do
    let(:user) { create(:user) }
    let!(:token) { user.generate_auth_token }
    allowed_attributes = %w(id email created_at)

    before do
      get api_v1_profiles_path, headers: { 'Authorization' => "Token token=#{token}" }
    end

    allowed_attributes.each do |attr|
      it "returns user #{attr}" do
        expect(response.body).to be_json_eql(user.send(attr.to_sym).to_json).at_path(attr)
      end
    end
  end
end
