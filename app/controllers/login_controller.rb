class LoginController < ApplicationController
  def get
  end

  def authenticate
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
    if not session[:user].nil?
      session[:user] = nil
    end
    redirect_to "http://127.0.0.1:3000/login/"
  end

  def signup
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
