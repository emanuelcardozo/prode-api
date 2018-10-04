class Stage
  include Mongoid::Document
  field :name, type: String
  field :is_current, type: Mongoid::Boolean

  has_many :matches
  belongs_to :tournament
end
