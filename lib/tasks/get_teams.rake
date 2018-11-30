require 'fileutils'
require 'net/http'

desc 'Getting all teams from the typed league'
task :get_teams, [:zone] => :environment do |task, args|

  url = URI.parse( Rails.application.config.scrapper_url + '/teams?country=' + (args[:zone] || 'argentina'))
  req = Net::HTTP::Get.new(url.to_s)
  res = Net::HTTP.start(url.host, url.port, :use_ssl => url.scheme == 'https') {|http|
    http.request(req)
  }
  teams = JSON.parse(res.body)
  teams.each do |team|
    new_team = Team.find_or_initialize_by(
      name: team["name"],
      logo: {
        small: team["logo"]["small"],
        medium: team["logo"]["medium"],
        large: team["logo"]["large"],
      }
    )
    new_team.save
  end
end
