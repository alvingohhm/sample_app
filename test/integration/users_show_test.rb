require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @non_admin = users(:archer)
    @unactivated_user = users(:malory)
  end

  test "should only show activated users" do
    log_in_as (@non_admin)
    get user_path(@unactivated_user)
    assert_redirected_to root_url
  end
end
