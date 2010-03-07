class UserController < ApplicationController

  before_filter :authentication_required
  before_filter :prepare

  def index
  end

  def edit
  end

  def refresh_token
    @user.refresh_token(params[:purpose])
  end

  private

  def prepare
    @user = current_user
  end

end
