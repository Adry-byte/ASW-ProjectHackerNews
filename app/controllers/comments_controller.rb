class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :update, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    @comments = Comment.all
    @replies = Reply.all
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end




  def reply
    if !current_user().nil?
        @comment = Comment.find(params[:id])
        @user_id = current_user().id
        @reply = @comment.replies.create(content:params[:content],user_id:@user_id)
        flash[:notice] = "Added your reply"
        redirect_to :action => "show", :id => params[:id]
    else
      redirect_to '/login'
    end
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @comment = Comment.new(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @comment, notice: 'Comment was successfully created.' }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    if params[:user][:password].blank?
      params[:user].delete(:password)
      params[:user].delete(:password_confirmation)
    end
    respond_to do |format|
      if @comment.update(params[:user])
        format.html { redirect_to @comment, notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /comments/threads
  def threads
    if params[:user_pk]
      @comments = Comment.where(user_id: params[:user_pk])
      @replies = Reply.where(user_id: params[:user_pk])

    else
      @comments = Comment.where(user_id: current_user().id)
      @replies = Reply.where(user_id: current_user().id)
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    if !current_user.nil?

      @comment = Comment.find(params[:id])
      @comment.upvote_by current_user
      redirect_to :back
    else
      redirect_to '/login'
    end

  end

  def downvote
    if !current_user.nil?
      @comment = Comment.find(params[:id])
      @comment.downvote_by current_user
      redirect_to :back
    else
      redirect_to '/login'
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      params.require(:comment).permit(:content)
    end
end
