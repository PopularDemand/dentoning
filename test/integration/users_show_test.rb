require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
	def setup
  	@user = users(:alexa)
  	@inactive_user = users(:michael)
  	@inactive_user.toggle!(:activated)
  	log_in_as(@user)
  end

  test 'should not show users that have not been activated' do
  	get user_path(@inactive_user)
  	assert_redirected_to root_url
  end

end
