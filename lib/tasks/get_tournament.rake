task :get_tournament => :environment do
  sh %{ node ./node/getTournament.js }
  file_path = 'node/super_liga.json'

  tournament = JSON.parse(File.read(file_path))
  # File.delete(file_path)
  new_tournament = Tournament.find_or_create_by(name: tournament["name"])

  new_tournament.save

  tournament["stages"].each_with_index do |stage, index|
    matches = stage["matches"]
    stage_status = matches.map{ |m| m["state"]}.uniq

    new_stage = Stage.find_or_create_by(
      name: stage["name"],
      number_of_stage: index+1,
      tournament_id: new_tournament.id,
    )
    new_stage.is_current = stage_status.include?('Pending')
    new_stage.finished = stage_status.length === 1 && stage_status.include?('Finished')

    new_stage.save

    matches.each do | match |
      date = match["schedule"]["date"]

      new_match = Match.find_or_create_by(
        home_id: Team.where(name: match["home"]["name"]).first.id,
        away_id: Team.where(name: match["away"]["name"]).first.id,
        tournament_id: new_tournament.id
      )

      new_match.home_goals = match["home"]["goals"]
      new_match.away_goals = match["away"]["goals"]
      new_match.date = date ? Date.strptime(date, '%d/%m/%Y') : nil
      new_match.hour = match["schedule"]["hour"]
      new_match.state = match["state"]
      new_match.stage_id = new_stage.id

      new_match.save
    end
  end

end
