require 'rails_helper'

RSpec.feature "Authentication", type: :feature do
  scenario 'user account registration (sign up)' do
    visit root_path
    click_on 'Sign up'
    fill_in 'Email', with: 'some@email.com'
    fill_in 'Password', with: 'password'
    click_on 'Sign up'
    expect(page).to have_current_path(account_path)
  end

  scenario 'user session creation (sign in)' do
    user = create :user

    visit root_path
    click_on 'Sign in'
    within('.sign-in') {
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Sign in'
    }
    expect(page).to have_current_path(account_path)
  end

  scenario 'user session removal (sign out)' do
    user = create :user

    visit root_path(as: user)
    # user automatically redirected from homepage
    # to /account currently
    expect(page).to have_current_path(account_path)
    click_on 'Sign out'
    visit account_path
    expect(page).to have_text('That doesn’t appear to belong to you.')
  end
end
