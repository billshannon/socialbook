require 'test_helper'

class UserTest < ActiveSupport::TestCase

  should have_many(:user_friendships)

  should have_many(:friends)

  test "a user should enter a first name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:first_name].empty?
  end

  test "a user should enter a last name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:last_name].empty?
  end

  test "a user should enter a profile name" do
  	user = User.new
  	assert !user.save
  	assert !user.errors[:profile_name].empty?
  end

  test "a user should have a unique profile name" do
    user = User.new
    user.profile_name = users(:rob).profile_name
    assert !user.save
    assert !user.errors[:profile_name].empty?
  end

  test "a user should have a profile name without spaces" do
    user = User.new(first_name: 'Rob', last_name: 'G', email: 'derp@derp.com')
    user.password = user.password_confirmation = 'dfwfdwdfwf'

    user.profile_name = "Herp Derp Lerp"

    assert !user.save
    assert !user.errors[:profile_name].empty?
    assert user.errors[:profile_name].include?("Must be formatted correctly.")
  end

  test "a user should have a correctly formatted profile name" do
    user = User.new(first_name: 'Rob', last_name: 'G', email: 'derp@derp.com')
    user.password = user.password_confirmation = 'dfwfdwdfwf'
    user.profile_name = 'derpyderpderps'

    assert user.valid?
    assert user.save
  end

  test "no error is raised when trying to access a friend list" do
    assert_nothing_raised do
      users(:rob).friends
    end
  end

  test "should create a friendship" do
    users(:rob).friends << users(:mike)
    users(:rob).friends.reload
    assert users(:rob).friends.include?(users(:mike))
  end

  test "calling to_param on user shows profile_name" do
    assert_equal "mikethefrog", users(:mike).to_param
  end
end
