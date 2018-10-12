class User
  include Mongoid::Document
  field :facebook_id, type: String

  has_many :bets
end
