class PointsController < ApplicationController

  def tournament_points
    tournament_points = users_tournament_points(params[:id]).map do |point| {
      user_facebook_id: point.user.facebook_id,
      name: point.user.name,
      points: point.total}
    end
    render :json => tournament_points
  end

  def stage_points
    all_stage_points = users_tournament_points(params[:id]).map do |user_tournament_points| {
        user_facebook_id: user_tournament_points.user.facebook_id,
        name: user_tournament_points.user.name,
        points: get_user_stage_points(user_tournament_points, params[:stage_number].to_i)
      }
    end
    render :json => all_stage_points
  end

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
