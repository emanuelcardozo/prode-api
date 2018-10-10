task :get_tournament => :environment do
  sh %{ node ./node/getTournament.js }
  file_path = 'node/super_liga.json'

  tournament = JSON.parse(File.read(file_path))
  File.delete(file_path)
  new_tournament = Tournament.find_or_create_by(name: tournament["name"])

  next if new_tournament.stages.count > 0

  tournament["stages"].each do |stage|
    matches = stage["matches"]
    stages = matches.map{ |m| m["state"]}.uniq

    new_stage = Stage.find_or_create_by(
      name: stage["name"],
      tournament_id: new_tournament.id,
      is_current: stages.include?('Pending'),
      finished: stages.length === 1 && stages.include?('Finished')
    )

    matches.each do | match |
      new_match = Match.find_or_create_by(
        home_id: Team.where(name: match["home"]["name"]).first.id,
        home_goals: match["home"]["goals"],
        away_id: Team.where(name: match["away"]["name"]).first.id,
        away_goals: match["away"]["goals"],
        date: Time.now,
        state: match["state"],
        stage_id: new_stage.id
      )
    end
  end


end
