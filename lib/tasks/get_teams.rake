require 'fileutils'

desc 'Getting all teams from the typed league'
task :load_team => :environment do
  sh %{ node ./node/getTeams.js }
  data = JSON.parse(File.read('node/teams.json'))
  data.each do |team|
    team = Team.find_or_initialize_by( name: team["name"], logo: team["logo"])
    team.save
  end
end
