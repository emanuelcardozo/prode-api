desc 'Getting all points obteined for each user'

  task :get_points => :environment do
  Match.where(points_recolected: false).to_a.map{ |match|
    h_goals = match.home_goals
    a_goals = match.away_goals

    match.bets.map{ |bet|

      guessed_home_goals = h_goals === bet.home_goals ? 1 : 0
      guessed_away_goals = a_goals === bet.away_goals ? 1 : 0
      guessed_result = (guessed_away_goals & guessed_home_goals) != 0 ? 1 : 0

      score = guessed_result + guessed_away_goals + guessed_home_goals

      point = Point.find_or_initialize_by(tournament_id: match.stage.tournament_id, user_id: bet.user_id)
      point.total += score
      point.history << {
        match_id: match.id,
        stage: match.stage.number_of_stage,
        points: score
      }
      point.save
    }
    match.update(points_recolected: true)
  }
end
