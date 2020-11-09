class ApplicationController < ActionController::Base
  before_action :auth

  def auth
    puts "authhhhhhhh"
    puts params
    prelogin_actions = ["get", "signup", "authenticate"]
    if not (params["controller"]=="login" and prelogin_actions.include?params["action"]) and session[:user].nil?
      redirect_to "http://127.0.0.1:3000/login/"
    end
    end
end
