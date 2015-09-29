require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

  test "login with invalid user information" do 
    get login_path
    assert_template 'sessions/new'
    post login_path, session: {email: '', password: ''}
    assert_template 'sessions/new'
    assert_not_empty flash
    get root_path
    assert_empty flash
  end

end
