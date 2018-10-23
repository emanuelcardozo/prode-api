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

    user = User.find_or_create_by(facebook_id: parsed_response["data"]["user_id"])

    if !user.name
      user.update!( name: params[:name],
                    email: params[:email],
                    picture: params[:picture][:data][:url],
                    token: token)
    end

    render :json => user
  end

  private

  def users_params
    params.permit(:accessToken, :userID, :name, :email)
  end
end
