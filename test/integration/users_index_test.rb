require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:example_user1)
    @admin = users(:admin_user)
  end

  test "index including pagination" do 
    log_in_as @user
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
    end
  end

  test "index as admin user; pagination and delete links" do
    log_in_as @admin
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user.admin?
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do 
      delete user_path(@user)
    end
  end

  test "index as non admin" do
    log_in_as @user
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end


end
