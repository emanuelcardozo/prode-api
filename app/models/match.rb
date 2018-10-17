class Match
  include Mongoid::Document
  field :state, type: String
  field :date, type: Time
  field :home_goals, type: Integer
  field :away_goals, type: Integer
  field :points_recolected, type: Mongoid::Boolean, default: false
  field :tournament_id, type: String

  belongs_to :home, class_name: 'Team'
  belongs_to :away, class_name: 'Team'

  belongs_to :stage
  has_many :bets
end
