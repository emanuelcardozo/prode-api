class Stage
  include Mongoid::Document
  field :name, type: String

  has_many :matches
  belongs_to :tournament
end
