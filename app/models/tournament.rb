class Tournament
  include Mongoid::Document
  field :name, type: String
  field :country, type: String

  has_and_belongs_to_many :teams
  has_many :stages
end
