class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

    # Both the Users controller and Microposts controller require this method, they are both 
    # sub-classes of Application Controller so will inherit this methd
   def logged_in_user
    unless logged_in?
      store_location #See sessions helper; this stores the GET request.url for friendly forwarding
      flash[:danger] = "Please login first."
      redirect_to login_url
    end
  end

end
