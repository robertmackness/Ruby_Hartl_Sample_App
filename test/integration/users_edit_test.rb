require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:example_user1)
  end


  test "unsuccessful user edit" do 
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), user: {   name: "",
                                      email: "foo@invalid",
                                      password: "foo",
                                      password_confirmation: "bar"}
    assert_template 'users/edit'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

end
