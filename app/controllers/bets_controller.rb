class BetsController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /bets
  # POST /bets.json
  def create
    params = bet_params
    @bet = Bet.find_or_initialize_by(match_id: params[:match_id], user: User.where(facebook_id: params[:user_id]).first)
    @bet.update(home_goals: params[:home_goals], away_goals: params[:away_goals])

    respond_to do |format|
      if @bet.save
        format.json { render json: @bet, status: :ok }
      else
        format.json { render json: {} , status: :unprocessable_entity }
      end
    end
  end

  private

    # Never trust parameters from the scary internet, only allow the white list through.
    def bet_params
      params.permit(:home_goals, :away_goals, :user_id, :match_id)
    end
end
