class BetsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /bets
  # POST /bets.json
  def create
    params = bet_params
    match = Match.find(params[:match_id])
    user = User.find_by(facebook_id: params[:user_id])
    if user.is_admin
      match.update(home_goals: params[:home_goals], away_goals: params[:away_goals], state: "Finished")
      render :json => "Partido actializado", :status => :ok
    else
      if match.state === "Finished" || deadline(match.date, match.hour)
        render :json => "Predicción rechazada: El partido no está disponible.", :status => 400
        return
      end

      @bet = Bet.find_or_initialize_by(match_id: match.id, user: User.find_by(facebook_id: params[:user_id]))
      @bet.update(home_goals: params[:home_goals], away_goals: params[:away_goals])

      respond_to do |format|
        if @bet.save
          format.json { render json: @bet, status: :ok }
        else
          format.json { render json: {} , status: :unprocessable_entity }
        end
      end
    end
  end

  def bets_of_match
    tournament = Tournament.find(params[:tournament_id])
    match = tournament.stages[params[:stage].to_i-1].matches.find(params[:match_id])
    bets = match.bets.map do |bet|
      {
        home_goals: bet.home_goals,
        away_goals: bet.away_goals,
        user_name: bet.user.name,
        user_alias: bet.user.alias,
        facebook_id: bet.user.facebook_id
      }
    end
    render :json => bets
  end

  private

  def bet_params
    params.permit(:home_goals, :away_goals, :user_id, :match_id)
  end

  def deadline date, hour
    dl = DateTime.now
    dl_hour = format('%02d', dl.hour)
    dl_min = format('%02d', dl.minute + 1)

    if date > Date.today
      return false
    elsif hour > (dl_hour + ":" + (dl_min == "60" ? "00" : dl_min))
      return false
    else
      return true
    end
  end
end
