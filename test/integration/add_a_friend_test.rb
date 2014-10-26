require 'test_helper'

class AddAFriendTest < ActionDispatch::IntegrationTest
  def sign_in_as(user, password)
    post login_path, user: { email: user.email, password: password }
  end

  test "adding a friend should work" do
    sign_in_as users(:rob), "testing"

    get "/user_friendships/new?friend_id=#{users(:mike).profile_name}"
    assert_response :success

    assert_difference 'UserFriendship.count' do
      post "/user_friendships", user_friendship: { friend_id: users(:mike).profile_name }
      assert_response :redirect
      assert_equal "New friend, Mike The Frog, added!", flash[:notice]
    end
  end
end
