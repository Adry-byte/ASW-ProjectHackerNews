class Api::CommentsController < Api::BaseController
  def show
    @comments = Comment.find(params[:id])
    respond_to do |format|
      format.json { render json: @comments}
    end
  end


  def new
    @user = User.find_by_apiKey(params[:apiKey])
    params.delete :apiKey

    if !@user.nil?
      @submission = Submission.find(params[:id])
      if @submission.nil?
        format.json { render status: :bad_request }
      end
      @comment = Comment.new(content: params[:content], user_id: @user.id, submission_id: params[:id])

      respond_to do |format|
        if @comment.save()
          format.json { render status: :created, json: @comment }
        else
          format.json { render status: :bad_request }
        end
      end
    else
      respond_to do |format|
        format.json { render json: {errors: 'Method not Allowed'}, status: :method_not_allowed }
      end
    end

  end

  def vote
    if !params[:apiKey].nil?
      @user = User.find_by_apiKey(params[:apiKey])
      @comment = Comment.find(params[:id])
      @comment.upvote_by @user
      respond_to do |format|
        format.json { render json: @comment, status: 200 }
      end
    else
      respond_to do |format|

        format.json { render json: {errors: 'Method not Allowed'}, status: :method_not_allowed }
      end
    end
  end


  def fromuser
    @comments = Comment.where(user_id:params[:id])
    if @comments.count > 0
      respond_to do |format|
        format.json { render json: @comments.to_json()}
      end
    else
      respond_to do |format|
        format.json { render json: {errors: 'No content'}, status: :no_content}
      end
    end

  end

  def threads
    @comments = Comment.where(user_id: params[:id])
    @replies = Reply.where(user_id: params[:id])

    array_of_json = @comments + @replies
    if array_of_json.count > 0
      respond_to do |format|
        format.json { render json: array_of_json.to_json(), status: 200}
      end
    else
      respond_to do |format|
        format.json { render json: {errors: 'No content'}, status: :no_content}
      end
    end
  end

end