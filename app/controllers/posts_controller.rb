class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  def create
    @post = Post.new(
      title: params[:title],
      content: params[:content],
      code: params[:code],
      user_id: @current_user.id)

    if @post.save
      flash[:notice] = 'Post was successfully created.'
      redirect_to(@post)
    else
      @error_message = "Failed."
      render("posts/new")
    end
  end

  # PATCH/PUT /posts/1
  def update
    @post.title = params[:title]
    @post.content = params[:content]
    @post.code = params[:code]

    if @post.save
      flash[:notice] = 'Post was successfully updated.'
      redirect_to(@post)
    else
      @error_message = "Failed."
      render("posts/edit")
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    flash[:notice] = 'Post was successfully destroyed.'
    redirect_to("/users/#{@current_user.id}")
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

end
