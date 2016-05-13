require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
  	ActionMailer::Base.deliveries.clear
  end

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

	test "valid signup information with acount activation" do
		get signup_path
		# Asserts a difference of 1 after code runs
		assert_difference "User.count", 1 do
			# follows the redirect after submission
			post users_path, user: { name: "Valid Name",
															 email: "user@example.com",
															 password: "password",
															 password_confirmation: "password"}
		end
		assert_equal 1, ActionMailer::Base.deliveries.size
		# assgns lets access instance variables in the corresponding action
		user = assigns(:user)
		assert_not user.activated?
		# Try to log in as user
		log_in_as(user)
		assert_not is_logged_in?

		#Invalid activation token
		get edit_account_activation_path("invalid token")
		assert_not is_logged_in?

		# Valid token, wrong email
		get edit_account_activation_path(user.activation_token, email: "wrong@example.com")
		assert_not is_logged_in?

		# Valid activation token
		get edit_account_activation_path(user.activation_token, email: user.email)
		assert user.reload.activated?

		follow_redirect!
		assert_template "users/show"
		assert is_logged_in?
		# assert_template "users/show"
		# assert_not flash.empty?
		# assert is_logged_in?
	end
end
