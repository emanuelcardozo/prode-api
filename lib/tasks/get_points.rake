desc 'Getting all points obteined for each user'
task :get_points => :environment do
  Match.where(points_recolected: false, state: "Finished", :_type.ne => "MainMatch").to_a.map{ |match|
    h_goals = match.home_goals
    a_goals = match.away_goals

    match.bets.map{ |bet|
      guessed_home_goals = h_goals === bet.home_goals ? 1 : 0
      guessed_away_goals = a_goals === bet.away_goals ? 1 : 0
      guessed_winner = (h_goals > a_goals && bet.home_goals > bet.away_goals) || (h_goals < a_goals && bet.home_goals < bet.away_goals) ||
                       (h_goals === a_goals && bet.home_goals === bet.away_goals) ? 1 : 0

      score = guessed_winner + guessed_away_goals + guessed_home_goals

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

  MainMatch.where(points_recolected: false, state: "Finished").to_a.map { |match|
    h_goals = match.home_goals
    a_goals = match.away_goals
    f_faul = match.first_faul
    y_card = match.yellow_card
    f_side = match.first_side
    f_corner = match.first_corner
    f_shot = match.first_shot
    f_offside = match.first_offside

    match.bet_matches.map { |bet|
      guessed_home_goals = h_goals === bet.home_goals ? 1 : 0
      guessed_away_goals = a_goals === bet.away_goals ? 1 : 0
      guessed_winner = (h_goals > a_goals && bet.home_goals > bet.away_goals) || (h_goals < a_goals && bet.home_goals < bet.away_goals) ||
                       (h_goals === a_goals && bet.home_goals === bet.away_goals) ? 1 : 0
      guessed_faul = f_faul === bet.first_faul ? 1 : 0
      guessed_side = f_side === bet.first_side ? 1 : 0
      guessed_shot = f_shot === bet.first_shot ? 1 : 0
      guessed_card = y_card === bet.yellow_card ? 1 : 0
      guessed_corner = f_corner === bet.first_corner ? 1 : 0
      guessed_offside = f_offside === bet.first_offside ? 1 : 0

      score = guessed_winner + guessed_away_goals + guessed_home_goals + guessed_faul + guessed_side + guessed_shot + guessed_shot + guessed_card + guessed_corner + guessed_offside

      point = Point.find_or_initialize_by(main_match_id: match.id, user_id: bet.user_id)
      point.total += score
      point.save
    }
    match.update(points_recolected: true)
  }
end
