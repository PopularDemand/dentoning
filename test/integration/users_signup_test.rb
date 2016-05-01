require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information" do
	  get signup_path
	  # Asserts that User.count will be no different
	  # after the code block runs
	  assert_no_difference 'User.count' do
	  	post users_path, user: { name: "",
	  													 email: "user@invalid",
	  													 password: "foo",
	  													 password_confirmation: "bar"}
	  end
	  assert_template 'users/new'
	end
end
