# Common Cucumber steps that set up a logged-in user for feature tests.
# Creates a test user (if needed) and sets the rack session user_id so UI tests run
# as an authenticated user.
#
# @param format [Symbol] example placeholder for documentation consistency
# @return [void] step definitions create/test-authenticate a user
# def to_format(format = :html)
#   # format the common steps description (example placeholder for YARD)
# end
#
Given('a user exists and is logged in') do
  @user ||= User.create!(email: 'test@example.com')
  page.set_rack_session(user_id: @user.id)
end
