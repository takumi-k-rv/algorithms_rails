# coding: utf-8
class ApplicationController < ActionController::Base
  before_action :set_current_user

  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  def forbid_not_logged_in
    if @current_user == nil
      flash[:notice] = "ログインが必要です"
      redirect_to("/login")
    end
  end

  def forbid_logged_in
    if @current_user
      flash[:notice] = "すでにログインしています"
      redirect_to("/users/")
    end
  end

end
