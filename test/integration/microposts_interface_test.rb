require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  
  def setup
  	@user = users(:alexa)
    @other_user = users(:adrian)
  	log_in_as(@user)
  end

  test "microposts interface" do
		get root_path
		assert_select 'div.pagination'
    assert_select 'input[type=file]'

		# Invalid submission
  	assert_no_difference "Micropost.count" do
  		post microposts_path, micropost: { content: "" }
  	end
  	assert_select 'div#error_explanation'

  	# Valid submission
  	content = "This is content for micropost"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
  	assert_difference "Micropost.count", 1 do
  		post microposts_path, micropost: { content: content, picture: picture }
  	end
  	assert_redirected_to root_url
  	follow_redirect!
  	assert_match content, response.body

  	# Delete a post
  	assert_select 'a', text: "delete"
  	first_micropost = @user.microposts.paginate(page: 1).first
  	assert_difference "Micropost.count", -1 do
  		delete micropost_path(first_micropost)
  	end

  	# Visit a different user
  	get user_path(users(:michael))
  	assert_select 'a', text: 'delete', count: 0
  end

  test "micropost sidebar count" do
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body

    log_in_as(@other_user)
    get root_path
    assert_match "0 microposts", response.body
    @other_user.microposts.create!(content: "Content")
    get root_path
    assert_match "1 micropost", response.body
  end
end
