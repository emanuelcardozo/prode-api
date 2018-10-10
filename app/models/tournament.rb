class Tournament < Predictable
  include Mongoid::Document
  field :name, type: String
  field :country, type: String
  field :image, type: String

  # has_many :teams
  has_many :stages
end
