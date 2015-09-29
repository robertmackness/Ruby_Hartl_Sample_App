require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  test "invalid signup information" do
    assert_no_difference('User.count') do
      get signup_path
      post users_path, user: {  name: "",
                                email: "user@invalid",
                                password: "foo",
                                password_confirmation: "bar" }
      end
      assert_template 'users/new'
      assert_select 'div#error_explanation'
      assert_select 'div.field_with_errors'
  end

  test "valid signup information" do
    assert_difference 'User.count', 1 do 
      get signup_path
      post_via_redirect users_path, user: {  name: "Test 1",
                                email: "test@example.com",
                                password: "foobar",
                                password_confirmation: "foobar" }
    end
    assert_template 'users/show'
    assert_not_empty flash
    #Tests don't have access to helper methods so we put this method in test_helper.rb 
    assert is_logged_in?
  end

end
