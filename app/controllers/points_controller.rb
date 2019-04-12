class PointsController < ApplicationController

  def tournament_points
    tournament_points = users_tournament_points(params[:id]).map do |point| {
      user_facebook_id: point.user.facebook_id,
      name: point.user.name,
      points: point.total
    }
    end

    render :json => tournament_points.sort_by{|user| -user[:points]}
  end

  def stage_points
    all_stage_points = users_tournament_points(params[:id]).map do |user_tournament_points|
      {
        user_facebook_id: user_tournament_points.user.facebook_id,
        name: user_tournament_points.user.name,
        alias: user_tournament_points.user.alias,
        facebook_id: user_tournament_points.user.facebook_id,
        points: get_user_stage_points(user_tournament_points, Stage.where(is_current: true).first.number_of_stage)
      }
    end
    render :json => all_stage_points.sort_by{|user| -user[:points]}
  end

  def main_match_points
    all_points = Point.where(main_match_id: params[:id]).to_a.map do | user_match_points |
      {
        facebook_id: user_match_points.user.facebook_id,
        name: user_match_points.user.name,
        alias: user_match_points.user.alias,
        points: user_match_points.total
      }
    end
    render :json => all_points.sort_by{ |user| -user[:points]}
  end

  private

  def users_tournament_points(id)
    Point.where(tournament_id: id).to_a
  end

  def get_user_stage_points(user_points, stage_number)
    points=0
    user_points.history.each do |match_points|
      points += match_points[:points] if match_points[:stage] === stage_number
    end
    points
  end

  def points_params
    params.permit(:id, :stage_number)
  end

end
