class QuestionController < ApplicationController
  def create
    # Creates a new post/question
    @post = Post.new(question)
    @post.like_count=0
    @post.dislike_count=0
    @post.reply_count=0
    @post.category="question"
    @post.user_id=session[:user]["id"]
    @post.parent_id=nil
    if @post.content and @post.save
      redirect_to :action => "list"
    else
      render :action => "new"
    end
  end

  def question
    params.require(:post).permit(:content)
  end

  def edit

  end

  def update

  end

  def delete
  end

  def list
    @questions = Post.includes(:user).includes(:user_actions).where("category='question'")
  end

  def download
    @questions = Post.includes(:user).includes(:user_actions).where("category='question'")
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "pdf"
      end
    end
  end

  def new
    @question = Post.new
  end


  def post_comment
    @post = Post.new
    @post.user_id=params["user_id"]
    @post.content=params["content"]
    @post.category="comment"
    @post.like_count=0
    @post.dislike_count=0
    @post.reply_count=0
    @post.parent_id=params["p-id"]
    @post.save

    post = Post.find(params["p-id"])
    post.reply_count += 1
    post.save
    render :json => {status: "success"}
  end

  def get_comments
    @post_id = params[:id]
    @comment_list = Post.where(parent_id: @post_id)

    render "get_comment.js"
  end

  def post_action
    @user_action = UserAction.new
    @user_action.post_id = params[:p_id]
    @user_action.user_id = params[:user_id]
    @user_action.action = params[:user_action]
    post = Post.find(params[:p_id])
    puts @user_action.action
    if @user_action.action.in? (["like", "dislike"])
      @existing_action = UserAction.where(:user_id => @user_action.user_id, :post_id => @user_action.post_id, :action=>["like", "dislike"]).all
      if @existing_action.blank?
        @user_action.save
        if @user_action.action == "like"
          post.like_count += 1
        else
          post.dislike_count += 1
        end
      else
        @existing_action.each do |record|
          if record.action != @user_action.action
            record.update_column("action", @user_action.action)
            record.update_column("updated_at", DateTime.now)
            if @user_action.action == "like"
              post.like_count += 1
              post.dislike_count -= 1
            else
              post.dislike_count += 1
              post.like_count -=1
            end
          end
        end
      end
      post.save
    end

    render :json => {status: "success"}
  end
end
