class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

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
    @user = User.new(name: params[:name], email: params[:email], password: params[:password])
    @user.image_name = "default.png"

    if @user.save
      flash[:notice] = 'User was successfully created.'
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

end
