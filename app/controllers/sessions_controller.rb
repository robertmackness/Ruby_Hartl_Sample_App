class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        log_in @user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      # Log the @user in and redirect to the @user's show page.
      redirect_back_or root_path
      else
      flash[:warning] = "Account not yet activated. Check your email for the activation link."
      redirect_to root_url
      end
    else
      # Create an error message.
      flash.now[:danger] = 'Incorrect email or password'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end

end
