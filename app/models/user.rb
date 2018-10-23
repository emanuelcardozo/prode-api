class User
  include Mongoid::Document
  field :name, type: String
  field :facebook_id, type: String
  field :email, type: String
  field :token, type: String
  field :picture, type: String

  has_many :bets
  has_many :points
end
