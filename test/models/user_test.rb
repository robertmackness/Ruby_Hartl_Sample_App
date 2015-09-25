require 'test_helper'

class UserTest < ActiveSupport::TestCase

  #run before each test
  def setup
    @user = User.new( name: "Example User", 
                      email: "user@example.com",
                      password: "foobar",
                      password_confirmation: "foobar")
    @user2 = User.new(name: "Example User 2", 
                      email: "user2@example.com",
                      password: "foobar2",
                      password_confirmation: "foobar2")
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

  test "email addresses should be unique" do 
    duplicate_user = @user.dup 
    duplicate_user.email.upcase!
    @user.save
    assert_not duplicate_user.valid?
  end

  test "passwords should be present (nonblank)" do 
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

end
