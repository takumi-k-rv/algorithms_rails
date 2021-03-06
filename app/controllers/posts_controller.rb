# coding: utf-8
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy, :authenticate_post]
  before_action :forbid_not_logged_in, except: [:index, :show]
  before_action :authenticate_post, only: [:edit, :update, :destroy]

  # GET /posts
  def index
    @posts = Post.page(params[:page]).per(5)
    if params[:tag_name]
      @posts = Post.tagged_with("#{params[:tag_name]}").page(params[:page]).per(5)
    end
  end

  # GET /posts/1
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
      flash[:success] = '投稿を作成しました'
      redirect_to(@post)
    else
      flash[:danger] = "失敗しました."
      redirect_to("/posts/new")
    end
  end

  # PATCH/PUT /posts/1
  def update
    @post.title = params[:title]
    @post.content = params[:content]
    @post.code = params[:code]
    @post.tag_list = params[:tag_list]

    if @post.save
      flash[:success] = '更新しました'
      redirect_to(@post)
    else
      flash[:danger] = "失敗しました"
      redirect_to("/posts/edit")
    end
  end

  # DELETE /posts/1
  def destroy
    @post.destroy
    flash[:success] = '削除しました'
    redirect_to("/users/#{@current_user.id}")
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    def authenticate_post
      if @current_user.id != @post.user_id && !@current_user.admin
        flash[:danger] = "権限がありません"
        redirect_to("/posts")
      end
    end

end
