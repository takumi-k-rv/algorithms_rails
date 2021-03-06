# coding: utf-8
class ApplicationController < ActionController::Base
  before_action :set_current_user

  add_flash_types :success, :info, :warning, :danger

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def forbid_not_logged_in
    if @current_user == nil
      flash[:danger] = "ログインが必要です"
      redirect_to("/login")
    end
  end

  def forbid_logged_in
    if @current_user && !@current_user.admin
      flash[:danger] = "すでにログインしています"
      redirect_to("/posts")
    end
  end

  def admin_only
    if @current_user && !@current_user.admin
      flash[:danger] = "権限がありません"
      redirect_to("/")
    end
  end

end
