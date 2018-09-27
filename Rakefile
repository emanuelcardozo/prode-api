# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

require 'fileutils'

task :get_data do
  sh %{ node ./node/getData.js }
end

task :load_team => :environment do
  sh %{ node ./node/getTeams.js }
  data = JSON.parse(File.read('node/teams.json'))
  data.each do |team|
    team = Team.find_or_initialize_by( name: team["name"], logo: team["logo"])
    team.save
  end
end
