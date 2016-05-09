require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:alexa)
	end

	test "index should include pagination" do
		log_in_as(@user)
		get users_path
		assert_template 'users/index'
		assert_select 'div.pagination'
		# paginate returns a 'chunk' of users from the db
		User.paginate(page: 1).each do |user|
			assert_select 'a[href=?]', user_path(user), text: user.name
		end
	end
end
