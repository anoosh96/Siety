require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
def setup

  @admin = users(:michael)
  @non_admin = users(:bob)

end




test "index as admin" do

    log_in_as(@admin)
    get users_path

    assert_template 'users/index'
    assert_select 'div.pagination'

    User.paginate(page: 1, per_page: 10).each do |user|

      assert_select "a[href=?]", user_path(user), text: user.name
      unless user == @admin
        assert_select "a[href=?]", user_path(user), text: "delete user"
      end
    end
 end

 test "index as non-admin" do
   log_in_as(@non_admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'

    assert_select 'a', text: 'delete', count: 0

    User.paginate(page: 1, per_page: 10).each do |user|

      assert_select "a[href=?]", user_path(user), text: user.name

    end

  end


end
