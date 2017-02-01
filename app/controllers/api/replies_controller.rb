class Api::RepliesController < Api::BaseController

  def new
    @user = User.find_by_apiKey(params[:apiKey])
    params.delete :apiKey

    if !@user.nil?
      @comment = Comment.find(params[:id])
      if @comment.nil?
        format.json { render status: :bad_request }
      end
      @reply = Reply.new(content: params[:content], user_id: @user.id, comment_id: params[:id])

      respond_to do |format|

        if @reply.save()
          format.json { render status: :created, json: @reply }
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


  def show
    @replies = Reply.find(params[:id])
	  respond_to do |format|
      format.json { render json: @replies, status: 200}
    end
  end

  def vote
    if !params[:apiKey].nil?

      @user = User.find_by_apiKey(params[:apiKey])
      @reply = Reply.find(params[:id])
      @reply.upvote_by @user
      respond_to do |format|
        format.json { render json: @reply, status: 200 }
      end
    else
      respond_to do |format|

        format.json { render json: {errors: 'Method not Allowed'}, status: :method_not_allowed }
      end
    end
  end


  def fromuser
    @replies = Reply.where(user_id:params[:id])
    if @replies.count > 0
      respond_to do |format|
        format.json { render json: @replies.to_json(), status: 200}
      end
    else
      respond_to do |format|
        format.json { render json: {errors: 'No content'}, status: :no_content}
      end
    end
  end
end