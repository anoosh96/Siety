require 'test_helper'

class PasswordResetTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

 def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:michael)
 end

  test "password_resets" do

     get new_password_reset_path

     assert_template 'password_resets/new'


     post password_resets_path params: {reset:{email: ""} }

     assert_not flash.empty?

     assert_template "password_resets/new"

     #valid email

     post password_resets_path params: {reset:{email: @user.email} }

     assert_not_equal @user.reset_digest, @user.reload.reset_digest

     assert_equal 1, ActionMailer::Base.deliveries.size

     assert_not flash.empty?

     assert_redirected_to root_url

     #password edit path


     user = assigns(:user)

     get edit_password_reset_url(user.reset_token,email: "")

     assert_redirected_to root_url

     user.toggle!(:activated)

     get edit_password_reset_url(user.reset_token,email: user.email)

     assert_redirected_to root_url

     user.toggle!(:activated)

     get edit_password_reset_url("wrong token",email: user.email)

     assert_redirected_to root_url

     get edit_password_reset_url(user.reset_token,email: user.email)

     assert_template 'password_resets/edit'
     assert_select "input[name=email][type=hidden][value=?]", user.email


    patch password_reset_path(user.token), params: {email: user.email, user:{password:"foobar",password_confirmation: "fooba"}}

    assert_template "password_resets/edit"
    assert_select "div#error_explanation"


    patch password_reset_path(user.token), params: {email: user.email, user:{password:"foobar",password_confirmation: "foobar"}}

    assert is_logged_in?

    assert_redirected_to user






  end

end
