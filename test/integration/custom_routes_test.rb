require 'test_helper'

class CustomRoutesTest < ActionDispatch::IntegrationTest
  test "/login route should open login page" do
  	get '/login'
  	assert_response :success
  end

  test "/logout route should open logout page" do
  	get '/logout'
  	assert_response :redirect
  	assert_redirected_to "/"
  end

  test "/register route should open sign up page" do
  	get '/register'
  	assert_response :success
  end

  test "a profile page works" do
    get "/" + users(:rob).profile_name
    assert_response :success
  end
end
