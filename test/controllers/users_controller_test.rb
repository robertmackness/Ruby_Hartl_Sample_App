require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
    @user1 = users(:example_user1)
    @user2 = users(:example_user2)
  end

  test "should GET new" do
    get :new
    assert_response :success
    assert_select "title", "Sign up | Ruby on Rails Tutorial Sample App"
  end

  test "should redirect GET edit if not logged in" do
    get :edit, id: @user1.id
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test "should redirect PATCH update when not logged in" do
    patch :update, id: @user1, user: { name: @user1.name, email: @user1.email }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect GET edit when logged in as wrong user" do 
    log_in_as @user2
    get :edit, id: @user1 
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect PATCH update when logged in as wrong user" do
    log_in_as @user2
    patch :update, id: @user1, user: { name: @user1.name, email: @user1.email }
    assert flash.empty?
    assert_redirected_to root_path
  end

  test "should redirect GET index if not logged in" do
    get :index
    assert_redirected_to login_path
  end

end
