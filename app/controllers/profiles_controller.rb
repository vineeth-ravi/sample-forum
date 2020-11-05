class ProfilesController < ApplicationController
  def get_profile
    @current_user_id = session[:user]["id"]
    @user_id = params[:id]
    @user = User.find(@user_id)
    @is_follow = "false"
    puts "hahaa"
    puts @current_user_id
    puts @user_id
    puts @current_user_id.eql?@user_id
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
    @user_id = params[:id]
    @questions = Post.includes(:user).includes(:user_actions).where(category: "question", user_id: @user_id)
    render "myquestions.js"
  end

  def get_answers_by_user
    @user_id = params[:id]
    @comment_list = Post.select(:parent_id).where(user_id: @user_id, category: "comment").distinct
    @questions = []
    @comment_list.each do |comment|
      @questions.append(Post.find(comment.parent_id))
    end
    render "myquestions.js"
  end

  def get_following
    @user_id = params[:id]
    @following_list = UserFollowDetail.where(user_id: @user_id)
    @user_list = []
    @following_list.each do |user|
      @user_list.append(User.find(user.following_user_id))
    end
    render "follow-details.js"
  end

  def get_followers
    @user_id = params[:id]
    @follower_list = UserFollowDetail.where(following_user_id: @user_id)
    @user_list = []
    @follower_list.each do |user|
      @user_list.append(User.find(user.user_id))
    end
    render "follow-details.js"
  end

  def update_following
    @action = params[:user_action]
    @user_id = params[:user_id]
    @following_user_id = params[:follow_user_id]
    if @user_id.to_i != session[:user]["id"].to_i
      return
    end
    @follower_list = UserFollowDetail.where(user_id: @user_id, following_user_id: @following_user_id)
    puts "cominggg"
    puts @action
    if @action == "follow"
      if @follower_list.blank?
        @follower_detail = UserFollowDetail.new
        @follower_detail.user_id = @user_id
        @follower_detail.following_user_id = @following_user_id
        @follower_detail.save
      end
    elsif @action == "unfollow"
      puts "unfolloww"
      if @follower_list.one?
        puts "going to deletee"
        @follower_list.first.delete
        puts "deleteedddd"
      end
    end
  end
end
