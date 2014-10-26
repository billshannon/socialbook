require 'test_helper'

class StatusesControllerTest < ActionController::TestCase

  setup do
    @status = statuses(:one)
  end

  test "should be logged in to post a status" do
    post :create, status: { content: "Hello"}
    assert_response :redirect
    assert_redirected_to new_user_session_path
    assert true
  end
  
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:statuses)
  end

  test "should be redirected when not logged in" do
    get :new
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should render the new page when logged in" do
    sign_in users(:rob)
    get :new
    assert_response :success
  end

  test "should create status when logged in" do
    sign_in users(:rob)
    assert_difference('Status.count') do
      post :create, status: @status.attributes
    end

    assert_redirected_to status_path(assigns(:status))
  end

  test "should create status for the current user when logged in" do
    sign_in users(:rob)
    assert_difference('Status.count') do
      post :create, status: { content: @status.content, user_id: users(:one).id }
    end

    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:rob).id
  end

  test "should show status" do
    get :show, id: @status
    assert_response :success
  end

  test "should be logged in to get edit" do
    get :edit, id: @status
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should get edit when logged in" do
    sign_in users(:rob)
    get :edit, id: @status
    assert_response :success
  end

  test "should be logged in to update" do
    patch :update, id: @status, status: { content: @status.content }
    assert_response :redirect
    assert_redirected_to new_user_session_path
  end

  test "should update status when logged in" do
    sign_in users(:rob)
    patch :update, id: @status, status: { content: @status.content }
    assert_redirected_to status_path(assigns(:status))
  end

  test "should update status for the current user when logged in" do
    sign_in users(:rob)
    patch :update, id: @status, status: { content: @status.content, user_id: users(:one).id }
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:rob).id
  end

  test "should not update status when nothing changes" do
    sign_in users(:rob)
    patch :update, id: @status
    assert_redirected_to status_path(assigns(:status))
    assert_equal assigns(:status).user_id, users(:rob).id
  end

  test "should destroy status if logged in" do
    sign_in users(:rob)
    assert_difference('Status.count', -1) do
      delete :destroy, id: @status
    end

    assert_redirected_to statuses_path
  end
end