class TournamentsController < ApplicationController

  def index
    tournaments = Tournament.all.to_a.map do |t|
      {
        id: t.id.to_s,
        name: t.name,
        country: t.country,
        img: t.img,
        # number_of_teams: t.teams.count,
        number_of_stages: t.stages.count
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
      stages_count: tournament.stages.count
    }
  end

  def teams
    render :json => Tournament.find( params[:id] ).teams
  end

  def stages
    stages = get_stages params[:id]
    render :json => stages.map{ |s| { name: s.name, matches: get_matches_data(s.matches) }}
  end

  def get_stages tournament_id
    Tournament.find( tournament_id ).stages
  end

  def get_matches_data matches
    matches.map do |match| {
      home: get_team_data(match.home, match.home_goals),
      away: get_team_data(match.away, match.away_goals),
      date: match.date,
      state: match.state }
    end
  end

  def get_team_data team, goals
    { name: team.name, logo: team.logo, goals: goals }
  end

  def stage
    stage = get_stages(params[:id])[params[:stage_number].to_i-1]
    render :json => { name: stage.name, matches: get_matches_data(stage.matches) }
  end

end
