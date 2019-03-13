class BetMatch
  include Mongoid::Document
  field :home_goals, type: Integer
  field :away_goals, type: Integer
  field :first_faul, type: Integer
  field :yellow_card, type: Integer
  field :first_side, type: Integer
  field :first_corner, type: Integer
  field :first_shot, type: Integer
  field :first_offside, type: Integer

  belongs_to :main_match
  belongs_to :user
end
