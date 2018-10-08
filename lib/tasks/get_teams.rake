require 'fileutils'

desc 'Getting all teams from the typed league'
task :get_teams => :environment do
  file_path = 'node/teams.json'
  sh %{ node ./node/getTeams.js }
  teams = JSON.parse(File.read(file_path))
  File.delete(file_path)
  teams.each do |team|
    new_team = Team.find_or_initialize_by( name: team["name"], logo: team["logo"])
    new_team.save
  end
end
