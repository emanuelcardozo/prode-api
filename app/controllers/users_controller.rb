require "uri"
require "net/http"

class UsersController < ApplicationController
  skip_before_action :authorize
  skip_before_action :verify_authenticity_token

  def register
    token = params[:accessToken]
    response = Net::HTTP.get( URI.parse("https://graph.facebook.com/debug_token?input_token=" + token + "&access_token=" + ENV['TOKEN']))
    parsed_response = JSON.parse(response)

    if parsed_response[:error]
      render :json => { error: "error from fb api" }
      return
    end

    user = User.find_or_create_by(facebook_id: parsed_response["data"]["user_id"])
    user.update!(name: params[:name], email: params[:email], token: token)

    render :json => user
  end

  def change_alias
    user = User.find_by(facebook_id: params[:user_id])
    user.update(alias: params[:alias])

    respond_to do |format|
      if user.save
        format.json { render json: user, status: :ok }
      else
        format.json { render json: {} , status: :unprocessable_entity }
      end
    end
  end
end
