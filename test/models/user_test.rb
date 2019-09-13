require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end'
  def setup
    @user = User.new(name:"Ahmed Anoosh", email: "ahmedanooshworks@gmail.com",password: "foobar", password_confirmation: "foobar");

  end


  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end


test "email addresses should be unique" do
  duplicate_user = @user.dup
  @user.save
  assert_not duplicate_user.valid?
 end

test "email addresses should be saved as lowercase" do
  mixed_case_email = "Foo@ExAMPle.CoM"
  @user.email = mixed_case_email
  @user.save
  assert_equal mixed_case_email.downcase, @user.reload.email
 end

 test "user with no password" do

    assert @user.valid?

 end

test "authenticated? should return false for a user with nil digest" do

    assert_not @user.authenticated?(:remember,'')

end

end
