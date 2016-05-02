module SessionsHelper

	# session is a seperate and distict method from the
	# session controller. Is provided by Rails.
	# This places a temporary cookie on browser
	# expires on browser close
	def log_in(user)
		session[:user_id] = user.id
	end

	# Returns the current logged-in user (if any)
	def current_user
		# stays as is (nil) or assigns by session user id
		# this opertor assigns the first true value
		@current_user ||= User.find_by(id: session[:user_id])	
	end

	# true if user is logged in
	def logged_in?
		!current_user.nil?
	end
end
