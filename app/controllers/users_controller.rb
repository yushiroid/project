class UsersController < ApplicationController
  skip_before_action :require_login, only: [:new, :create, :edit]
  before_action :set_user, only: [:show, :destroy, :edit, :update, :mypage]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    if @user.save
      login(params[:user][:email], params[:user][:password])
      redirect_to root_path, notice: 'ユーザー登録しました。'
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_path, notice: '更新完了しました.' }
        format.json { render :show, status: :ok, location: @user }
        flash[:success] = "ユーザ登録情報更新"
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  #Upload Picture


  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def mypage
    @groups = current_user.groups
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end


    # Never trust parameters from the scary internet, only allow the white list through.

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
    end

    def attr
      params.require(:user).permit(:email, :password, :password_confirmation, :authentications_attributes)
    end



end
