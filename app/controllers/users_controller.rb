# coding: utf-8
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_only, only: [:index]
  before_action :forbid_logged_in, only: [:new, :create, :login_form, :login]
  before_action :forbid_not_logged_in, only: [:index, :edit, :update, :destroy, :logout]
  before_action :authenticate_user, only: [:edit, :update, :destroy]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
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
  def create
    if @current_user && @current_user.admin
      @user = User.new(
        name: params[:name],
        email: params[:email],
        image_name: "default.png",
        password: params[:password],
        admin: params[:admin]
      )
    else
     @user = User.new(
      name: params[:name],
      email: params[:email],
      image_name: "default.png",
      password: params[:password]
    )
    end

    if @user.save
      flash[:success] = 'ユーザーを作成しました'
      if @current_user && @current_user.admin
        redirect_to(users_path)
      else
        session[:user_id] = @user.id
        redirect_to(@user)
      end
    else
      flash[:danger] = 'Failed'
      redirect_to("/users/new")
    end
  end

  # PATCH/PUT /users/1
  def update
    @user.name = params[:name]
    @user.email = params[:email]

    if params[:image_name]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end

    if @current_user.admin
      @user.admin = params[:admin]
    end

    if @user.save
      flash[:success] = '更新しました'
      if @current_user.admin
        redirect_to("/users")
      else
        redirect_to(@user)
      end
    else
      flash[:danger] = 'Failed'
      redirect_to("/users/#{@user.id}/edit")
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    flash[:success] = '削除しました'
    if !@current_user.admin
      redirect_to("/")
    else
      redirect_to("/users")
    end
  end

  # GET /login
  def login_form
  end

  # POST /login
  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:success] = "ログインしました"
      redirect_to("/posts")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  # POST /logout
  def logout
    session[:user_id] = nil
    flash[:success] = "ログアウトしました"
    redirect_to("/login")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def authenticate_user
      if @current_user.id != @user.id && !@current_user.admin
        flash[:danger] = "権限がありません"
        redirect_to("/posts")
      end
    end

end
