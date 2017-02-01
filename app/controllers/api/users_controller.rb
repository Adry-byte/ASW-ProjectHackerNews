class Api::UsersController < Api::BaseController
  require 'securerandom'

  def show
    @users = User.find(params[:id])
    respond_to do |format|
      format.json { render json: @users.to_json()}
    end
  end


  def existFacebook
    @users = User.where(username: params[:apiKey])
    if !@users.nil?
      @user = @users[0]
      respond_to do |format|
        format.json { render json: {id: @user.id, email: @user.email, apiKey: @user.apiKey}}
      end
    else
      format.json { render json: {error:'not found'}, status: :not_found }
    end
  end

  def create
    @user = User.new(user_params)
    @user.karma = 0
    respond_to do |format|
      if @user.save
        @apiKey = (@user.id).to_s + "_" + SecureRandom.urlsafe_base64
        @user.apiKey = @apiKey
        @user.save
        format.json { render json: {id: @user.id, email: @user.email, apiKey: @user.apiKey}, status: :created}
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def createFacebook
    @user = User.new(user_params)
    @user.karma = 0
    respond_to do |format|
      if @user.save
        @apiKey = (@user.id).to_s + "_" + SecureRandom.urlsafe_base64
        p @apiKey
        @user.apiKey = @apiKey
        @user.save
        format.json { render json: {id: @user.id, email: @user.email, apiKey: @user.apiKey}, status: :created}
      else
        p @user.errors
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end


  def update
    @userAK = User.find_by_apiKey(params[:apiKey])
    @user = User.find(params[:id])
    if @userAK.id == @user.id
      respond_to do |format|
        if @user.update(user_params_edit)
          format.json { render status: :ok, json: @user }
        else
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end

    else
      respond_to do |format|
        format.json { render json: {errors: 'Method not Allowed'}, status: :method_not_allowed }
      end
    end
  end

    def user_params
      params.permit(:username, :password, :email, :about)
    end

    def user_params_edit
      params.permit(:username, :email, :password, :password_confirmation, :about)
    end

  end
