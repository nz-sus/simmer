# spec/system/user_login_spec.rb
require 'rails_helper'

RSpec.describe 'User Login', type: :system, js: true do
  let(:user) { create(:user) }

  before do
    driven_by(:selenium_chrome_headless)
  end

  it 'allows a user to log in' do
    visit new_user_session_path

    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password

    click_button 'Sign in'

    expect(page).to have_content 'Signed in successfully'
  end

  it 'allows a user to log out' do
    login_as(user, scope: :user)

    visit root_path
    accept_confirm do
      click_link 'Logout'
    end

    expect(page).to have_content 'Signed out successfully'
  end
end
