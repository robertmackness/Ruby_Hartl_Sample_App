module SessionsHelper


#Logs in the given user by issuing a temporary encrypted cookie containing the user id
#Is ONLY called after successful database authentication check from Sessions Controller
  def log_in(user) do
    session[:user_id] = user.id
  end

  #Request the current user from session[:user_id] if it exists, otherwise return nil
  #Note the OR-Equals, this prevents multiple DB lookups if the current user value is called
  #multiple times across the site
  def current_user do
    @current_user ||= User.find_by(session[:user_id])
  end

end
