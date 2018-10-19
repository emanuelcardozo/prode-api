class User
  include Mongoid::Document
  field :name, type: String
  field :facebook_id, type: String
  field :email, type: String

  has_many :bets
  has_many :points
end
