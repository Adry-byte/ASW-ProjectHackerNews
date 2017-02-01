class Api::SubmissionsController < Api::BaseController

  def show
    @submissions = Submission.find(params[:id])
    respond_to do |format|
      format.json { render json: @submissions}
    end
  end

  def todas
    @submissions = Submission.where(tipo:'url')
    respond_to do |format|
      format.json { render json: @submissions}
    end
  end

  def ask
    @submissions = Submission.where(tipo:'text')
    respond_to do |format|
      format.json { render json: @submissions}
    end
  end


  def new
    if !params[:apiKey].nil?

      @user = User.find_by_apiKey(params[:apiKey])
      params.delete :apiKey

      @submission = Submission.new(submission_params)
      if @submission.url.nil?
        @submission.tipo = "text"
      else
        if !@submission.url.nil?
            if @submission.url != ""
              @submission.tipo = "url"
            else
              @submission.tipo = "text"
            end
          end
      end


      respond_to do |format|
        @submission.user_id = @user.id
        if @submission.save
          format.json { render :show, status: :created, json: @submission }
        else
          format.json { render json: @submission.errors, status: :unprocessable_entity }
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
      @submission = Submission.find(params[:id])
      @submission.upvote_by @user
      respond_to do |format|
        format.json { render json: @submission, status: 200 }
      end
    else
      respond_to do |format|
        format.json { render status: :method_not_allowed }
      end
    end
  end

  def fromuser
    @submissions = Submission.where(user_id:params[:id])
    if @submissions.count > 0
      respond_to do |format|
        format.json { render json: @submissions.to_json(), status: 200}
      end
    else
      respond_to do |format|
        format.json { render json: {errors: 'No content'}, status: :no_content}
      end
    end


  end



  def submission_params
    params.permit(:title, :url, :content, :tipo)
  end

end