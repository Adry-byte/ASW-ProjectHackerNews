class AuthenticationsController < ApplicationController
  before_action :set_authentication, only: [:show, :edit, :update, :destroy]

  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = current_user.authentications if current_user
  end

  # GET /authentications/1
  # GET /authentications/1.json
  def show
  end

  # GET /authentications/new
  def new
    @authentication = Authentication.new
  end

  # GET /authentications/1/edit
  def edit
  end

  # POST /authentications
  # POST /authentications.json
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.where(:provider => omniauth['provider'], :uid => omniauth['uid']).first
    if authentication
      flash[:notice] = t(:signed_in)
      #sign_in_and_redirect(:user, authentication.user)
      log_in(authentication.user)
      #render :text => authentication.user['username']
      redirect_to edit_user_path authentication.user_id

    elsif current_user
      current_user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = t(:success)
      redirect_to edit_user_path current_user.__id__
    elsif user = create_new_omniauth_user(omniauth)
      user.authentications.create!(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = t(:welcome)
      #sign_in_and_redirect(:user, user)
      log_in(user)
      #render :text => user.to_xml
      #redirect_to authentications_url
      redirect_to edit_user_path user.id
      #render :text => omniauth.to_json
    #else
      #flash[:alert] = t(:fail)
      #redirect_to login_path
      #render :text => omniauth.to_json
    end

  end

  # PATCH/PUT /authentications/1
  # PATCH/PUT /authentications/1.json
  def update
    respond_to do |format|
      if @authentication.update(authentication_params)
        format.html { redirect_to @authentication, notice: 'Authentication was successfully updated.' }
        format.json { render :show, status: :ok, location: @authentication }
      else
        format.html { render :edit }
        format.json { render json: @authentication.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy
    flash[:notice] = t(:successfully_destroyed_authentication)
    redirect_to authentications_url
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_authentication
    @authentication = Authentication.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def authentication_params
    params.require(:authentication).permit(:user_id, :provider, :uid)
  end

  def create_new_omniauth_user(omniauth)
    user = User.new
    user.apply_omniauth(omniauth)
    if user.save
      user
    else
      nil
    end
  end

end