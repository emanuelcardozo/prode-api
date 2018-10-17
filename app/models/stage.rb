class Stage
  include Mongoid::Document
  field :name, type: String
  field :number_of_stage, type: Integer
  field :is_current, type: Mongoid::Boolean
  field :finished, type: Mongoid::Boolean

  has_many :matches
  belongs_to :tournament
end
