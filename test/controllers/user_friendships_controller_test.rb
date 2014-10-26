require 'test_helper'

class UserFriendshipsControllerTest < ActionController::TestCase

  context "#new" do
    context "not logged in" do
      should "redirect to the login page" do
        get :new
        assert_response :redirect
      end
    end

    context "logged in" do
      setup do
        sign_in users(:rob)
      end

      should "get new and return success" do
        get :new
        assert_response :success
      end

      should "should set a flash error if the friend_id is missing" do
        get :new, {}
        assert_equal "Friend Required", flash[:error]
      end

      should "display the friend's name" do
        get :new, friend_id: users(:mike)
        assert_match /#{users(:mike).full_name}/, response.body
      end

      should "assign a new user friendship" do
        get :new, friend_id: users(:mike)
        assert assigns(:user_friendship)
      end

      should "assign a new user friendship to the correct friend" do
        get :new, friend_id: users(:mike)
        assert_equal users(:mike), assigns(:user_friendship).friend
      end

      should "assign the currently logged in user to new friendship" do
        get :new, friend_id: users(:mike)
        assert_equal users(:rob), assigns(:user_friendship).user
      end

      should "show a 404 if friend can't be found" do
        get :new, friend_id: "invalid"
        assert_response :not_found
      end

      should "ask if you really want to request this friendship" do
        get :new, :friend_id => users(:mike)
        assert_match /Do you really want to friend #{users(:mike).full_name}?/, response.body
      end
    end
  end

  context "#create" do
    context "not logged in" do
      should "redirect to the login page" do
        get :new, friend_id: users(:mike)
        assert_response :redirect
        assert_redirected_to login_path
      end
    end

    context "logged in" do
      setup do
        sign_in users(:rob)
      end

      context "no friend_id" do
        setup do
          post :create
        end

        should "set the flash error message" do
          assert_not_empty flash[:error]
        end

        should "redirected to the root path" do
          assert_redirected_to root_path
        end
      end

      context "valid friend_id" do
        setup do
          post :create, user_friendship: { friend_id: users(:mike) }
        end

        should "get a friend assigned" do
          assert assigns(:friend)
          assert_equal users(:mike), assigns(:friend)
        end

        should "assign a user_friendship object" do
          assert assigns(:user_friendship)
          assert_equal users(:rob), assigns(:user_friendship).user
          assert_equal users(:mike), assigns(:user_friendship).friend
        end

        should "create a friendship" do
          assert users(:rob).friends.include?(users(:mike))
        end

        should "redirect to the profile page of the friend" do
          assert_redirected_to profile_path(users(:mike))
        end

        should "set the flash success message" do
          assert flash[:success]
        end
      end
    end
  end
end
