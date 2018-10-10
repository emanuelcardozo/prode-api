class Team
  include Mongoid::Document
  field :name, type: String
  field :logo, type: Hash, default: {}
  field :country, type: String
  field :status, type: Mongoid::Boolean, default: true

  has_many :matches, :inverse_of => :home
  has_many :matches, :inverse_of => :away
  # belongs_to :tournament
end
