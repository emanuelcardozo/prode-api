require "uri"
require "net/http"

class UsersController < ApplicationController

  def register
    token = params[:accessToken]
    response = Net::HTTP.get( URI.parse("https://graph.facebook.com/debug_token?input_token=" + token + "&access_token=" + ENV['TOKEN']))
    parsed_response = JSON.parse(response)

    if parsed_response[:error]
      render :json => { error: "error from fb api" }
      return
    end

    User.find_or_create_by(facebook_id: parsed_response["data"]["user_id"]) do |user|
      user.token= params[:accessToken],
      user.name= params[:name],
      user.email= params[:email]
    end

    render :json => "ok"
  end

  private

  def users_params
    params.permit(:accessToken, :userID, :name, :email)
  end
end
