class Match
  include Mongoid::Document
  field :state, type: String
  field :date, type: Time
  field :home_goals, type: Integer
  field :away_goals, type: Integer

  belongs_to :home, class_name: 'Team'
  belongs_to :away, class_name: 'Team'

  belongs_to :stage
end
