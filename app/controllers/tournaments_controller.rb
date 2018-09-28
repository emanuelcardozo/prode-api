class TournamentsController < ApplicationController

  def index
    render :json => Tournament.all
  end

  def show
    render :json => Tournament.find(params[:id])
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
    stages = get_stages params[:id]
    render :json => {name: stages.first.name, matches: stages.first.matches}
  end

end
