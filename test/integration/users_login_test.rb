require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

def setup
  #Here users refers to the users.yml fixtures
  @user = users(:example_user1)
end

  test "login with invalid user information" do 
    get login_path
    assert_template 'sessions/new'
    post login_path, session: {email: '', password: ''}
    assert_template 'sessions/new'
    assert_not_empty flash
    get root_path
    assert_empty flash
  end

  test "login with valid user information" do
    get login_path
    assert_template 'sessions/new'
    post login_path, session: {email: @user.email, password: 'password'}
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end

end
