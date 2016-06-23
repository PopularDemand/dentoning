require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
                     password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "name should be present" do
    @user.name = "     "
    assert_not @user.valid?
  end

  test "email should be present" do
    @user.email = "    "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a"*244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.com
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user@example.
                           foo@bar_baz.com foo@bar+baz.com email@this..com]
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address.inspect} should be invalid"
    end
  end

  test "email addresses should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end

  test "user email should be lowercase" do
    mixed_case_email = "tHiS@fOo.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "password should be present" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for user with nil remember digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "microposts are dependent on deletion" do
    @user.save
    @user.microposts.create!(content: "content")
    assert_difference "Micropost.count", -1 do
      @user.destroy
    end
  end

  test "should follow and unfollow a user" do
    sandra = users(:sandra)
    elvis  = users(:elvis)
    assert_not sandra.following?(elvis)
    sandra.follow(elvis)
    assert sandra.following?(elvis)
    assert elvis.followers.include?(sandra)
    sandra.unfollow(elvis)
    assert_not sandra.following?(elvis)
  end

  test "feed should have the correct posts" do
    alexa   = users(:alexa)
    michael = users(:michael)
    elvis   = users(:elvis)
    # Has posts from followed user
    michael.microposts.each do |post_following|
      assert alexa.feed.include?(post_following)
    end
    # Has posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # No posts from unfollowed user
    alexa.microposts.each do |post_unfollowed|
      assert_not elvis.feed.include?(post_unfollowed)
    end
  end

end