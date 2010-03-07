# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password

  before_filter :authentication
  prepend_before_filter :authenticate_by_token

  class TokenError < StandardError
  end

  rescue_from TokenError do
    message = { :message => "Token error.", :status => false }
    render :json => message, :callback => params[:callback], :status => 403
  end

  private

  def current_user
    @login_user if defined?(@login_user)
  end

  def authenticate_by_token
    return true unless params[:token]
    self.class.skip_before_filter :verify_authenticity_token
    @token = Token.find_by_token_and_purpose(params[:token], 'API')
    if @token
      @login_user = @token.user
      session[:user_id] = @login_user.id
    else
      logger.info "::: Token not found! ::: #{params[:token]}" if params[:token]
      raise TokenError
    end
    true
  end
end
