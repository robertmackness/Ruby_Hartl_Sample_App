class SessionsController < ApplicationController
  
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      # Log the user in and redirect to the user's show page.
      redirect_to user
    else
      # Create an error message.
      flash.now[:danger] = 'Incorrect email or password'
      render 'new'
    end
  end

  def destroy
  end

end
