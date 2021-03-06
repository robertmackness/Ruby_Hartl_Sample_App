require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:example_user1)
    @user2 = users(:example_user2)
    @content = "This is just some example content"
  end

  test "micropost interface" do 
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    
    # Invalid submission
    assert_no_difference 'Micropost.count' do 
      post microposts_path, micropost: {content: ""}
    end
    assert_select 'div#error_explanation'
    
    # Valid submission
    assert_difference 'Micropost.count', 1 do
      post microposts_path, micropost: {content: @content}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match @content, response.body

    # Delete a post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    # Visit a different user, ensure no delete option avail
    get user_path(users(:example_user2))
    assert_select 'a', text: 'delete', count: 0
  end

  test "pluralization for microposts" do 
    log_in_as @user2 
    get root_path
    assert_match "#{@user2.microposts.count} microposts", response.body
    delete micropost_path(@user2.microposts.last)
    get root_path
    assert_match '1 micropost', response.body
    delete micropost_path(@user2.microposts.first)
    get root_path
    assert_match '0 microposts', response.body
  end

end
