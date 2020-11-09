class LoginController < ApplicationController
  def get
    # it renders the login page
  end

  def authenticate
    # authenticate is used to authenticate - email & password match, the post request from login page
    # It also stores the user information in the session
    user = params[:user]
    if not user.nil?
      user_info = User.where(email_id: user[:email_id], password: user[:password])
      if user_info.any?
        redirect_to :action => "list", controller: "question"
        session[:user] = user_info.first
      else
        puts "faill"
      end
    end
  end

  def logout
    # destroys the user info from the session
    if not session[:user].nil?
      session[:user] = nil
    end
    redirect_to "http://127.0.0.1:3000/login/"
  end

  def signup
    # Creates new user account
    user = User.new
    puts params
    user.first_name = params[:user][:first_name]
    user.last_name = params[:user][:last_name]
    user.email_id = params[:user][:email_id]
    user.password = params[:user][:password]
    user.save
    user.user_id = user.id
    user.save
    authenticate
  end
end
