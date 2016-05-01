class UsersController < ApplicationController
  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  	# debugger
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      flash[:success] = "Welcome to the community!" #flash hash is available to first page after redirect
  		redirect_to @user #same as user_url(@user)
  	else
  		render 'new'
  	end  	
  end

  private

  	# Requires a user object in params
  	# Permits the given input fields, and nothing more
  	def user_params
  		params.require(:user).permit(:name, :email, :password,
  																 :password_confirmation)
  	end
end
