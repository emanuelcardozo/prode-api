class TournamentsController < ApplicationController

  def index
    tournaments = Tournament.all.to_a.map do |t|
      {
        id: t.id,
        name: t.name,
        country: t.country,
        number_of_teams: t.teams.count,
        number_of_stages: t.stages.count
      }
    end

    render :json => tournaments
  end

  def show
    tournament = Tournament.find(params[:id])

    render :json => {
      id: tournament.id,
      name: tournament.name,
      country: tournament.country,
      stages_count: tournament.stages.count
    }
  end

  def teams
    render :json => Tournament.find( params[:id] ).teams
  end

  def stages
    stages = get_stages params[:id]
    render :json => stages.map{ |s| { name: s.name, matches: s.matches }}
  end

  def get_stages tournament_id
    Tournament.find( tournament_id ).stages
  end

  def stage
    stage = get_stages(params[:id])[params[:stage_number].to_i-1]
    render :json => {
      name: stage.name,
      matches: stage.matches.map do |match| {
        home: {
          name: match.home.name,
          logo: match.home.logo,
          goals: match.home_goals,
        },
        away: {
          name: match.away.name,
          logo: match.away.logo,
          goals: match.away_goals,
        },
        date: match.date,
        state: match.state,
        }
      end
    }
  end

end
