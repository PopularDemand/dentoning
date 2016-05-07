module SessionsHelper

	# session is a seperate and distict method from the
	# session controller. Is provided by Rails.
	# This places a temporary cookie on browser
	# expires on browser close
	def log_in(user)
		# cookies.signed is more secure than just cookies
		session[:user_id] = user.id
	end

	# Returns the current logged-in user (if any)
	def current_user
		# stays as is (nil) or assigns by session user id
		# this opertor assigns the first true value
		# @current_user ||= User.find_by(id: cookies[:user_id])	
		if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
				log_in user
				@current_user = user
			end
		end
	end

	def remember(user)
		# Call to user model method
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end
	
	# Forgets persistent session
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	# Logs out current user
	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	# true if user is logged in
	def logged_in?
		!current_user.nil?
	end
end
