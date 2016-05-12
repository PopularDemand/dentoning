require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "account_activation" do
    user = users(:alexa)
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal "Account Activation",        mail.subject
    assert_equal [user.email],                mail.to
    # Configure environments/tests.rb with domain host example.com
    assert_equal ["noreply@example.com"],     mail.from
    assert_match user.name,                   mail.body.encoded
    assert_match user.activation_token,       mail.body.encoded
    assert_match CGI::escape(user.email),     mail.body.encoded
  end

  test "password_reset" do
  end

end
