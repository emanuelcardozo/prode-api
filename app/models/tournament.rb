class Tournament
  include Mongoid::Document
  field :name, type: String
  field :country, type: String
  field :img, type: String

  # has_many :teams
  has_many :stages
end
