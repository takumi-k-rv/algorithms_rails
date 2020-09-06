class BookmarksController < ApplicationController
  before_action :forbid_not_logged_in

  # post /bookmark/:user_id/create
  def create
    @bookmark = Bookmark.new(user_id: @current_user.id, post_id: params[:post_id])
    @bookmark.save
    redirect_to("/posts/#{params[:post_id]}")
  end

  def destroy
    @bookmark = Bookmark.find_by(user_id: @current_user.id, post_id: params[:post_id])
    @bookmark.destroy
    redirect_to("/posts/#{params[:post_id]}")
  end
end
