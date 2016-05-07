require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

	def setup
		# users refers to users.yml
		@user = users(:alexa)
	end

  test "login with invalid params" do
		get login_path
		assert_template 'sessions/new'
		post login_path, session: { email: "", password: "" }
		assert_not flash.empty?
		get root_path
		assert flash.empty?
  end

  test "login with valid params followed by logout" do
  	get login_path
  	post login_path, session: { email: @user.email,
  															password: 'password' }
  	assert_redirected_to @user
  	follow_redirect!
  	assert_template "users/show"
  	assert_select "a[href=?]", login_path, count: 0
  	assert_select "a[href=?]", logout_path
  	assert_select "a[href=?]", user_path(@user)

  	delete logout_path
  	assert_not is_logged_in?
  	assert_redirected_to root_url
    # Simulate user clicking log out in a second window
    delete logout_path
  	follow_redirect!
  	assert_select "a[href=?]", login_path
  	assert_select "a[href=?]", logout_path, count: 0
  	assert_select "a[href=?]", user_path(@user), count: 0
  end

  test 'login with remembering' do
    log_in_as(@user, remember_me: '1')
                   # cookies only takes string parameters
    assert_not_nil cookies['remember_token']
  end

  test 'login without remembering' do
    log_in_as(@user, remember_me: '0')
    assert_nil cookies['remember_token']
  end
end
