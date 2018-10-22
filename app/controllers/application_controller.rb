class ApplicationController < ActionController::Base

  def authorize
    current_user.present?
  end

  def current_user
    @current_user ||= User.find_by(token: params[:accessToken])
  end

end
