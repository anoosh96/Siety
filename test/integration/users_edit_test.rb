require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
def setup
  @user = users(:michael)
end

 test "unsuccessful edit" do

    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: {name:"" ,email:"abc@invalid",password:"123",password_confirmation:"123"} }
    assert_template 'users/edit'

 end


 test "successful edit" do

    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name ="Johnny"
    email ="abc@valid.com"
    patch user_path(@user), params: {user: {name:name ,email:email,password:"123123",password_confirmation:"123123"} }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?

    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email


 end

 test "successful edit with friendly forwarding" do

    get edit_user_path(@user)
    assert_redirected_to login_path
    follow_redirect!

    log_in_as(@user)

    assert_redirected_to edit_user_path(@user)
    follow_redirect!

    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name, email: email, password: "123123", password_confirmation: "123123" } }
     assert_not flash.empty?
     assert_redirected_to @user
     follow_redirect!

     @user.reload
     assert_equal name, @user.name
     assert_equal email, @user.email


 end


end
