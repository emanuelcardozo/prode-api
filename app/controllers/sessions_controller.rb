class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_or_initialize_by(facebook_id: params[:userID])
    user.update(name: params[:name], email: params[:email], facebook_id: params[:userID])

    respond_to do |format|
      if user.save
        session[:user_id] = user.id
        format.json { render json: user, status: :ok }
      else
        format.json { render json: {} , status: :unprocessable_entity }
      end
    end
  end

  def destroy
    session[:user_id] = nil
  end

  def session_params
    params.permit(:userID, :name, :email)
  end
end
