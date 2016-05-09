class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

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
      log_in @user
      flash[:success] = "Welcome to the community!" #flash hash is available to first page after redirect
      redirect_to @user #same as user_url(@user)
  	else
  		render 'new'
  	end  	
  end

  def edit
    # removed @user assignment because @user is assigned in before action (correct_user)
    # @user = User.find(params[:id])
  end

  def update
    # removed @user assignment because @user is assigned in before action (correct_user)
    # @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = 'Profile successfully updated!'
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  	# Requires a user object in params
  	# Permits the given input fields, and nothing more
  	def user_params
  		params.require(:user).permit(:name, :email, :password,
  																 :password_confirmation)
  	end

    # Confirms a logged in user
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms the correct user
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
