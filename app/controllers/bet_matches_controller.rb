class BetMatchesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    match = MainMatch.find(params[:match_id])
    user = User.find_by(facebook_id: params[:user_id])
    if user.is_admin
      match.update(home_goals: params[:gHome], away_goals: params[:gAway],
                  first_faul: params[:foul], yellow_card: params[:yCard],
                  first_side: params[:lateral], first_corner: params[:corner],
                  first_shot: params[:sOnTarget], first_offside: params[:offside], state: "Finished")
      render :json => "Partido actializado", :status => :ok
    else
      if match.state === "Finished" || deadline(match.date, match.hour)
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

  private
  def deadline date, hour
    dl = DateTime.now
    dl_hour = format('%02d', dl.hour)
    dl_min = format('%02d', dl.minute - 1)

    if date > Date.today
      return false
    elsif hour > (dl_hour + ":" + (dl_min == "-1" ? "59" : dl_min))
      return false
    else
      return true
    end
  end
end
