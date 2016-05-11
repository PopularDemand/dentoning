class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: [:destroy]

  def new
  	@user = User.new
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

  def show
    @user = User.find(params[:id])
    # debugger
  end

  def index
    # @users = User.all
    # paginate page key is what page is being accessed
    # shows 30 resources by default
    @users = User.paginate(page: params[:page])
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

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted."
    redirect_to users_url
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
        # Defined in session helper
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

    # Confirms an admin user
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
