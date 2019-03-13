class MainMatch < Match
  include Mongoid::Document
  field :stadium, type: String
  field :first_faul, type: Integer, default: 0
  field :yellow_card, type: Integer, default: 0
  field :first_side, type: Integer, default: 0
  field :first_corner, type: Integer, default: 0
  field :first_shot, type: Integer, default: 0
  field :first_offside, type: Integer, default: 0

  has_many :bet_matches
end
