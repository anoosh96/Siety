require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end


 test "microposts come in order" do

   assert_equal microposts(:most_recent), Micropost.first

 end

end
