require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

	def setup
		@admin = users(:alexa)
		@non_admin = users(:michael)
		log_in_as(@admin)
	end

	test "user index should not show non-activated users" do
		@non_admin.toggle!(:activated)
		get users_path
		assert_select 'a[href=?]', user_path(@non_admin), false
	end

	test "index as admin should include pagination and delete links" do
		# log_in_as(@admin)
		get users_path
		assert_template 'users/index'
		assert_select 'div.pagination'
		# paginate returns a 'chunk' of users from the db
		first_page_of_users = User.paginate(page: 1)
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

end