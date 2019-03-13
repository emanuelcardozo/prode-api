class BetMatchesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    match = MainMatch.find(params[:match_id])

    if match.state != "Pending"
      render :json => "Predicción rechazada: El partido no está disponible.", :status => 400
      return
    end

    @bet = BetMatch.find_or_initialize_by(main_match_id: match.id, user: User.find_by(facebook_id: params[:user_id]))
    @bet.update(home_goals: params[:gHome], away_goals: params[:gAway],
                first_faul: params[:foul], yellow_card: params[:yCard],
                first_side: params[:lateral], first_corner: params[:corner],
                first_shot: params[:sOnTarget], first_offside: params[:offside])

    respond_to do |format|
      if @bet.save
        format.json { render json: @bet, status: :ok }
      else
        format.json { render json: {} , status: :unprocessable_entity }
      end
    end
  end

end
