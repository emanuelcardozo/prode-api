class ApplicationController < ActionController::Base
  before_action :authorize

  def authorize
    render :json, text: "unauthorized" and return if current_user.nil?
  end

  def current_user
    @current_user ||= User.find_by(token: params[:accessToken])
  end
end
