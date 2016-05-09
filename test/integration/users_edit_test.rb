require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:alexa)
	end

	test "does not update with invalid information" do
		get edit_user_path(@user)
		assert_template 'users/edit'
		patch user_path(@user), user: { name: "",
																		email: "this.invalid",
																		password: "foo",
																		password_confirmation: "bar"}
		assert_template 'users/edit'
	end

	test 'updates the user if valid information' do
		get edit_user_path(@user)
		assert_template 'users/edit'
		name = "Valid Name"
		email = 'test@test.com'
		patch user_path(@user), user: { name: name,
																		email: email,
																		password: "",
																		password_confirmation: "" }
		assert_not flash.empty?
		assert_redirected_to @users
		@user.reload
		assert_equal name, @user.name
		assert_equal email, @user.email
	end

end
