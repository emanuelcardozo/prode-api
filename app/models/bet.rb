class Bet
  include Mongoid::Document
  field :home_goals, type: Integer
  field :away_goals, type: Integer

  belongs_to :match
  belongs_to :user
end
