require 'rails_helper'
require 'acceptance_helper'

feature 'First sign in', %q{
  As a user
  I want to sign in after registered
} do

  include_context 'users'

  context 'as user' do
    scenario 'Sign in' do
      visit new_user_session_path

      within '#new_user' do
        fill_in 'user_email', with: user.email
        fill_in 'user_password', with: user.password
        click_on t('devise.sessions.new.sign_in')
      end

      expect(current_path).to eq authenticated_root_path
      expect(page).to have_content t('devise.sessions.signed_in')
      expect(page).to have_content t('devise.sessions.signed_in')
    end
  end
end
