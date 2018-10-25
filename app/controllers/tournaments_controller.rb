class TournamentsController < ApplicationController
  def index
    tournaments = Tournament.all.to_a.map do |t|
      {
        id: t.id.to_s,
        name: t.name,
        country: t.country,
        img: t.img,
        # number_of_teams: t.teams.count,
        current_stage: t.stages.where(is_current: true).first.name
      }
    end

    render :json => tournaments
  end

  def show
    tournament = Tournament.find(params[:id])

    render :json => {
      id: tournament.id.to_s,
      name: tournament.name,
      country: tournament.country,
      # number_of_teams: t.teams.count,
      current_stage: tournament.stages.where(is_current: true).first.name
    }
  end

  def teams
    render :json => Tournament.find( params[:id] ).teams
  end

  def stages
    stages = get_stages params[:id]
    render :json => stages.map{ |s| { name: s.name, matches: get_matches_data(s.matches) }}
  end

  def stage
    stage = get_stages(params[:id])[params[:stage_number].to_i-1]
    render :json => { name: stage.name, matches: get_matches_data(stage.matches) }
  end

  def states
    tournament = Tournament.find(params[:id])
    render :json => tournament.stages.map{ |s| s.finished }
  end

  private

  def get_stages tournament_id
    Tournament.find( tournament_id ).stages
  end

  def get_matches_data matches
    matches.map do |match|

      bet = match.bets.where(user_id: @current_user.id).first
      match_points = @current_user.points.first.history.select{|p| p[:match_id] === match.id}.first[:points] if match.points_recolected

      {
        id: match.id.to_s,
        home: get_team_data(match.home, match.home_goals),
        away: get_team_data(match.away, match.away_goals),
        bet_home: bet ? bet.home_goals : nil,
        bet_away: bet ? bet.away_goals : nil,
        points: match_points,
        date: (match.date.strftime("%d/%m/%y") if match.date),
        hour: match.hour,
        state: match.state
      }
    end
  end

  def get_team_data team, goals
    { name: team.name,
      logo: {
        small: team.logo["small"],
        medium: team.logo["medium"],
        large: team.logo["large"]
      },
      goals: goals }
  end

  def tournament_params
    params.permit(:id, :stage_number)
  end

end
