module SessionsHelper
  
  # logs in the current user
  def log_in(user)
    #session creates a temporary cookie.
    session[:user_id] = user.id
  end
  
  #remember a use in a persistent session
  def remember(user)
    user.remember
    
    #both lines perform same function. .permanent makes the expiration 20 years, .signed encrypt user_id
    #cookies[:user_id] = { value: user.id, expires: 20.years.from_now.utc }
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
  
  # Forget a persistant session
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  
  # returns the current logged in user
  def current_user
    
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
      # above line does what the code below does.     
      #    if @current_user.nil?
      #      @current_user = User.find_by(id: session[:user_id])
      #    else
      #      @current_user
      #    end
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end

  end
  
  # returns true if user is logged in
  def logged_in?
    !current_user.nil?
  end
  
  #logs out the user
  def log_out
    forget(current_user)
    session.delete(:user_id)
    # alternate: session[:user_id] = nil
    @current_user = nil
  end
end
