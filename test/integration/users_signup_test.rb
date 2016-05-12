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
	  assert_select 'div#error_explanation'
	  assert_select 'div.field_with_errors'
	end

	test "valid signup information" do
		get signup_path
		# Asserts a difference of 1 after code runs
		assert_difference "User.count", 1 do
			# follows the redirect after submission
			post_via_redirect users_path, user: { name: "Valid Name",
															 email: "user@example.com",
															 password: "password",
															 password_confirmation: "password"}
		end
		# assert_template "users/show"
		# assert_not flash.empty?
		# assert is_logged_in?
	end
end
