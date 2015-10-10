require 'test_helper'

class UserTest < ActiveSupport::TestCase

  #run before each test
  def setup
    @user = User.new( name: "Archer", 
                      email: "archer@example.com",
                      password: "foobar",
                      password_confirmation: "foobar")
    @user2 = User.new(name: "Lana", 
                      email: "lana@example.com",
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

  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "passwords should be present (nonblank)" do 
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have a minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do 
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed upon user destruction" do 
    @user.save
    @user.microposts.create!(content: "Lorem ipsum")
    assert_difference 'Micropost.count', -1 do 
      @user.destroy 
    end
  end

  test "should follow and unfollow a user" do
    elmo = users(:example_user1)
    grouch = users(:example_user2)
    assert_not elmo.following?(grouch)
    elmo.follow(grouch)
    assert elmo.following?(grouch)
    assert grouch.followers.include?(elmo)
    elmo.unfollow(grouch)
    assert_not elmo.following?(grouch)
  end

  test "feed should have the right posts" do
    bert      = users(:bert)
    big_bird  = users(:big_bird)
    the_count = users(:the_count)
    elmo      = users(:example_user1)
    # Posts from followed user
    the_count.microposts.each do |followed_posts|
      assert bert.feed.include?(followed_posts)
      assert big_bird.feed.include?(followed_posts)
    end
    # Posts from self
    bert.microposts.each do |self_posts|
      assert bert.feed.include?(self_posts)
    end
    # Posts from unfollowed user
    big_bird.microposts.each do |unfollowed_posts|
      assert_not elmo.feed.include?(unfollowed_posts)
    end
  end
end
