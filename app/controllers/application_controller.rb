class ApplicationController < ActionController::Base
  before_action :auth

  def auth
    # Authenticates the signed in pages if the user information is available in the session
    # if the user information is not available, redirect to the login page
    prelogin_actions = ["get", "signup", "authenticate"]
    if not (params["controller"]=="login" and prelogin_actions.include?params["action"]) and session[:user].nil?
      redirect_to "http://127.0.0.1:3000/login/"
    end
  end
end
