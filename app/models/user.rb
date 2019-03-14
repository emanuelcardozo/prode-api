class User
  include Mongoid::Document
  field :name, type: String
  field :facebook_id, type: String
  field :email, type: String
  field :token, type: String
  field :picture, type: String
  field :alias, type: String, default: ""
  field :is_admin, type:  Mongoid::Boolean, default: false

  has_many :bets
  has_many :bet_matchs
  has_many :points
end
