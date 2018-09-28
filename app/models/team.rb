class Team
  include Mongoid::Document
  field :name, type: String
  field :logo, type: String
  field :country, type: String
  field :status, type: Mongoid::Boolean, default: true

  has_many :matches, :inverse_of => :home
  has_many :matches, :inverse_of => :away
  has_and_belongs_to_many :tournaments
end
