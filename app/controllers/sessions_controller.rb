class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
  		# Log in and redirect to show
  	else
  		# USe flash.now for actions that render not redirect
  		flash.now[:danger] = 'Invalid email/password'
  		render 'new'
  	end
  end

  def destroy
  end
end
