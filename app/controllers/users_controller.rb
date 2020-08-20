# coding: utf-8
class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user, only: [:edit, :update, :destroy]
  before_action :forbid_not_logged_in, only: [:new, :create, :login_form, :login]
  before_action :forbid_logged_in, only: [:index, :show, :edit, :update, :destroy, :logout]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @user = User.find_by(id: params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    @user = User.find_by(id: params[:id])
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(name: params[:name], email: params[:email], password: params[:password])
    @user.image_name = "default.png"

    if @user.save
      flash[:notice] = 'User was successfully created.'
      session[:user_id] = @user.id
      redirect_to(@user)
    else
      @error_message = "Failed."
      render("users/new")
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    @user.name = params[:name]
    @user.email = params[:email]

    if params[:image_name]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end

    if @user.save
      flash[:notice] = 'User was successfully updated.'
      redirect_to(@user)
    else
      @error_message = "Failed."
      render("users/new")
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    flash[:notice] = 'User was successfully destroyed.'
    redirect_to(users_url)
  end

  # GET /login
  def login_form
  end

  # POST /login
  def login
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/users")
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
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def authenticate_user
      if @current_user.id != params[:id]
        flash[:notice] = "権限がありません"
        redirect_to("/users")
      end
    end

end
