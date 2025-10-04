Given('a user exists and is logged in') do
  @user ||= User.create!(email: 'test@example.com')
  page.set_rack_session(user_id: @user.id)
end
