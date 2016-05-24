require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
  def setup
  	@user       = users(:alexa)
  	@other_user = users(:michael)
  end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect from edit to login if not logged in" do
  	# automatically uses @user.id
  	get :edit, id: @user
  	assert_not flash.empty?
  	assert_redirected_to login_url
  end

  test "should redirect from update when not logged in" do
  	patch :update, id: @user, user: { name: @user.name, email: @user.email }
  	assert_not flash.empty?
  	assert_redirected_to login_url
  end

  test "should redirect edit when logged in as wrong user" do
  	log_in_as(@user)
  	get :edit, id: @other_user
  	assert flash.empty?
  	assert_redirected_to root_url
  end

  test "should redirect update when logged in as wrong user" do
  	log_in_as(@other_user)
  	patch :update, id: @user, user: { name: @user.name, email: @user.email }
  	assert flash.empty?
  	assert_redirected_to root_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

  # To test this, uncomment :admin in user_params
  test 'admin attribute should not be editable through web' do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch :update, id: @other_user, user: { password: @other_user.password,
                                            password_confirmation: @other_user.password,
                                            admin: true}
    @other_user.save!
    assert_not @other_user.admin?
  end

  test "should redirect from followers when not logged in" do
    get :followers, id: @user
    assert_redirected_to login_url
  end
end
