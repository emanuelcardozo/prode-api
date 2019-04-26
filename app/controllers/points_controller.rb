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
    tournament_id = params[:id]
    stage_number = Stage.where(is_current: true).first.number_of_stage
    users = User.where(:is_admin.ne => true).to_a
    all_stage_points = users.map do |user_tournament_points|
      {
        user_facebook_id: user_tournament_points.facebook_id,
        name: user_tournament_points.name,
        alias: user_tournament_points.alias,
        facebook_id: user_tournament_points.facebook_id,
        points: get_user_stage_points(user_tournament_points, tournament_id, stage_number),
      }
    end
    render :json => all_stage_points.sort_by{|user| -user[:points]}
  end

  def main_match_points
    users = Point.where(main_match_id: params[:id]).to_a
    if users.empty?
      users = User.where(:is_admin.ne => true).to_a
      all_points = users.map do | user_match_points |
        {
          facebook_id: user_match_points.facebook_id,
          name: user_match_points.name,
          alias: user_match_points.alias,
          points: 0
        }
      end
    else
      all_points = users.map do | user_match_points |
        {
          facebook_id: user_match_points.user.facebook_id,
          name: user_match_points.user.name,
          alias: user_match_points.user.alias,
          points: user_match_points.total
        }
      end
    end
    render :json => all_points.sort_by{ |user| -user[:points]}
  end

  private

  def users_tournament_points(id)
    Point.where(tournament_id: id).to_a
  end

  def get_user_stage_points(user, tournament_id, stage_number)
    points=0
    up = Point.where(user_id: user.id, tournament_id: tournament_id).first
    if(up)
      user_points = up.history.select {|h| h['stage'] === stage_number}
      user_points.each do |match_points|
        points += match_points[:points]
      end
    end
    points
  end

  def points_params
    params.permit(:id, :stage_number)
  end

end
