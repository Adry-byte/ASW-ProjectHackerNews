class SubmissionsController < ApplicationController
  before_action :set_submission, only: [:show, :update, :destroy]

  # GET /submissions
  # GET /submissions.json
  def index

    if params[:user_pk]
      @submissions = Submission.where(user_id:params[:user_pk])
      @boolShowAsk = true
    else
      @submissions = Submission.all
      @boolShowAsk = false

    end
  end

  # GET /submissions/ask
  def ask
    @submissions = Submission.all
  end


  # GET /submissions/1
  # GET /submissions/1.json
  def show
  end

  def comment
    if !current_user().nil?
      @user_id = current_user().id
      @submission = Submission.find(params[:id])
      @comment = @submission.comments.create(content: params[:content], user_id: @user_id)
      flash[:notice] = "Added your comment"
      redirect_to :action => "show", :id => params[:id]
    else
      redirect_to '/login'
    end
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
  end

  # GET /submissions/1/edit
  #def edit
  #end

  # POST /submissions
  # POST /submissions.json
  def create
    if !current_user().nil?

      @submission = Submission.new(submission_params)
      if @submission.url.empty?
        @submission.tipo = "text"
      else
        @submission.tipo = "url"
      end

      respond_to do |format|
        @submission.user_id= current_user().id
        if @submission.save
          format.html { redirect_to @submission, notice: 'Submission was successfully created.' }
          format.json { render :show, status: :created, location: @submission }
        else
          format.html { render :new }
          format.json { render json: @submission.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to '/login'
    end
  end

  # PATCH/PUT /submissions/1
  # PATCH/PUT /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to @submission, notice: 'Submission was successfully updated.' }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1
  # DELETE /submissions/1.json
  def destroy
    @submission.destroy
    respond_to do |format|
      format.html { redirect_to submissions_url, notice: 'Submission was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote
    if !current_user.nil?

      @submission = Submission.find(params[:id])
      @submission.upvote_by current_user
      redirect_to :back
    else
      redirect_to '/login'
    end

  end

  def downvote
    if !current_user.nil?
      @submission = Submission.find(params[:id])
      @submission.downvote_by current_user
      redirect_to :back
    else
      redirect_to '/login'
    end

  end



  private
  # Use callbacks to share common setup or constraints between actions.
  def set_submission
    @submission = Submission.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def submission_params
    params.require(:submission).permit(:title, :url, :content, :tipo)
  end
end
