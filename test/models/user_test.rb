require 'test_helper'

class UserTest < ActiveSupport::TestCase

  #run before each test
  def setup
    @user = User.new(name: "Example User", email: "user@example.com")
    @user2 = User.new(name: "Example User 2", email: "user2@example.com")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "name should be shorter than 50 characters" do 
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "  "
    assert_not @user.valid?
  end

  test "email should be an email" do
    @user.email = "12345@example,com"
    assert_not @user.valid?
  end

  test "email should not be longer than 255 characters" do 
    @user.email = "a"*255 + "@example.com"
    assert_not @user.valid?
  end

end
