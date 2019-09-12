require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  def setup

   @user = users(:bob)

  end



  test "should get new" do
    get signup_path
    assert_response :success
  end



  test "should redirect when non admin" do

     assert_no_difference 'User.count' do

        delete user_path(@user)
      end
      assert_redirected_to login_path
      follow_redirect!

      log_in_as(@user)

      assert_redirected_to @user

  end








end
