class ProfilesController < ApplicationController
  def get_profile
    # returns the following user information for the given profile/user id and renders the home page
    #   1. user information of the requested profile - first name, last name
    #   2. if currently logged in profile is same as requested profile - is_follow => self
    #   3. if the active logged in profile follows the requested profile when the both are different profiles - is_follow => (true/false)
    #   4. render profile.html template
    @current_user_id = session[:user]["id"]
    @user_id = params[:id]
    @user = User.find(@user_id)
    @is_follow = "false"
    if @current_user_id.to_i === @user_id.to_i
      @is_follow = "self"
    else
      is_following = UserFollowDetail.where(user_id: @current_user_id, following_user_id: @user_id)
      if is_following.any?
        @is_follow = "true"
      end
    end
    render "profile.html"
  end
  def get_questions_by_user
    # returns the questions that were asked by the requested user
    @user_id = params[:id]
    @questions = Post.includes(:user).includes(:user_actions).where(category: "question", user_id: @user_id)
    render "myquestions.js"
  end

  def get_answers_by_user
    # returns the questions where the requested user answered/commented atleast once.
    @user_id = params[:id]
    @comment_list = Post.select(:parent_id).where(user_id: @user_id, category: "comment").distinct
    @questions = []
    @comment_list.each do |comment|
      @questions.append(Post.find(comment.parent_id))
    end
    render "myquestions.js"
  end

  def get_following
    # get profiles that the currently logged in user is following
    @user_id = params[:id]
    @following_list = UserFollowDetail.where(user_id: @user_id)
    @user_list = []
    @following_list.each do |user|
      @user_list.append(User.find(user.following_user_id))
    end
    render "follow-details.js"
  end

  def get_followers
    # get profiles those were following the currently logged in user
    @user_id = params[:id]
    @follower_list = UserFollowDetail.where(following_user_id: @user_id)
    @user_list = []
    @follower_list.each do |user|
      @user_list.append(User.find(user.user_id))
    end
    render "follow-details.js"
  end

  def update_following
    #update the following details (follow/unfollow) by the currently logged in user to any other user/profile
    @action = params[:user_action]
    @user_id = params[:user_id]
    @following_user_id = params[:follow_user_id]
    if @user_id.to_i != session[:user]["id"].to_i
      return
    end
    @follower_list = UserFollowDetail.where(user_id: @user_id, following_user_id: @following_user_id)
    if @action == "follow"
      if @follower_list.blank?
        @follower_detail = UserFollowDetail.new
        @follower_detail.user_id = @user_id
        @follower_detail.following_user_id = @following_user_id
        @follower_detail.save
      end
    elsif @action == "unfollow"
      if @follower_list.one?
        @follower_list.first.delete
      end
    end
  end
end