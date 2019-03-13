class Point
  include Mongoid::Document
  field :total, type: Integer, default: 0
  field :history, type: Array, default: []
  field :tournament_id, type: String
  field :main_match_id, type: String

  belongs_to :user
end
