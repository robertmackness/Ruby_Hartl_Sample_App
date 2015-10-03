require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

def setup
  @user = users(:example_user1)
end

test "layout links when not signed in" do
  get root_path
  assert_template 'static_pages/home'
  assert_select "a[href=?]", root_path,     count: 2
  assert_select "a[href=?]", help_path,     count: 1
  assert_select "a[href=?]", about_path,    count: 1
  assert_select "a[href=?]", contact_path,  count: 1
  assert_select "a[href=?]", signup_path,   count: 1
  assert_select "a[href=?]", login_path,    count: 1
  assert_select "a[href=?]", users_path,    count: 0
end

test "layout links when signed in as user" do
  get root_path
  assert_template 'static_pages/home'
  log_in_as @user
  assert_redirected_to @user
  follow_redirect!
  assert_template 'users/show'
  assert_select "a[href=?]", root_path,    count: 2
  assert_select "a[href=?]", help_path,    count: 1
  assert_select "a[href=?]", about_path,   count: 1
  assert_select "a[href=?]", contact_path, count: 1
  assert_select "a[href=?]", signup_path,  count: 0
  assert_select "a[href=?]", login_path,   count: 0
  assert_select "a[href=?]", 
                edit_user_path(@user.id),  count: 1
  assert_select "a[href=?]", logout_path,  count: 1
  assert_select "a[href=?]", users_path,   count: 1
end

end
