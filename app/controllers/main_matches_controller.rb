class MainMatchesController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
    match = get_match_data
    render :json => match
  end

  def get_match_data
    mmatch = MainMatch.last
    bet = {}
    if mmatch
      bet = mmatch.bet_matches.where(user_id: @current_user.id).first
      {
        id: mmatch.id.to_s,
        home: get_team_data(mmatch.home),
        away: get_team_data(mmatch.away),
        bet_home: bet ? bet.home_goals : nil,
        bet_away: bet ? bet.away_goals : nil,
        bet_faul: bet ? bet.first_faul : nil,
        bet_side: bet ? bet.first_side : nil,
        bet_corner: bet ? bet.first_corner : nil,
        bet_shot: bet ? bet.first_shot : nil,
        bet_offside: bet ? bet.first_offside : nil,
        bet_card: bet ? bet.yellow_card : nil,
        date: (mmatch.date.strftime("%d/%m/%y") if mmatch.date),
        hour: mmatch.hour,
        state: mmatch.state,
        stadium: mmatch.stadium,
        stage: mmatch.stage.name,
        tournament: mmatch.stage.tournament.name
      }
    end
    bet
  end

  def get_team_data team
    { name: team.name,
      logo: {
        small: team.logo["small"],
        medium: team.logo["medium"],
        large: team.logo["large"]
      },
      id: team.id
    }
  end
end
