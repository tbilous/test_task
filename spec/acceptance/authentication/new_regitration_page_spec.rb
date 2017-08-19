require 'rails_helper'
require 'acceptance_helper'

feature 'New registration', %q{
  As a user
  I want to register
} do

  include_context 'users'

  context 'as user' do
    let(:user) { attributes_for(:user) }
    scenario 'Create profile' do
      visit new_user_registration_path

      within '#new_user' do
        fill_in 'user_email', with: user[:email]
        fill_in 'user_password', with: user[:password]
        fill_in 'user_password_confirmation', with: user[:password_confirmation]
        click_on t('devise.registrations.new.sign_up')
      end

      expect(current_path).to eq authenticated_root_path
      expect(page).to have_content t('devise.registrations.signed_up')
    end
  end
end
