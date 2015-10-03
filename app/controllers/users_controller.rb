class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:edit, :update, :index, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(user_params)
      if @user.save
        log_in @user
        remember @user
        flash[:success] = "Welcome to the Sample App!"
        redirect_to @user
      else
        render 'new'
      end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User successfully destroyed"
    redirect_to users_path
  end

  # BEFORE FILTERS
  def logged_in_user
    unless logged_in?
      store_location #See sessions helper; this stores the GET request.url for friendly forwarding
      flash[:danger] = "Please login first."
      redirect_to login_url
    end
  end

  def edit
  @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile successfully updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end
