require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @unactivated_user = users(:malory)
  end
  
  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.where(activated: true).paginate(page: 1)
    # first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index only show activated user" do
    log_in_as(@admin)
    get users_path
    total_paginate_pages = User.where(activated: true).paginate(page: 1).total_pages
    (1..total_paginate_pages).each do |page_no|
      get users_path(page: page_no)
        assert_select 'a[href=?]', user_path(@unactivated_user), text: @unactivated_user.name, count: 0
    end
  end
# test "index as admin including pagination and delete links" do
#     log_in_as(@admin)
#     get users_path
#     assert_template 'users/index'
#     assert_select 'div.pagination'
#     final_page_count = User.paginate(page: 1).total_pages
#     (1..final_page_count).each do |page_no|
#       puts "page:#{page_no}"
#       first_page_of_users = User.paginate(page: page_no)
#       get users_path(page: page_no)
#       puts @response.body
#       first_page_of_users.each do |user|
#         debugger
        
#         if user.activated?
#           puts "activated list: #{user.name} | #{user.activated} | #{user_path(user)}"
#           assert_select 'a[href=?]', user_path(user), text: user.name
#           unless user == @admin
#             assert_select 'a[href=?]', user_path(user), text: 'delete'
#           end
#         else
#           puts "not activated list: #{user.name} | #{user.activated} | #{user_path(user)}"
#           assert_select 'a[href=?]', user_path(user), false
#         end
#       end
#      end
#     assert_difference 'User.count', -1 do
#       delete user_path(@non_admin)
#     end
#   end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

end
