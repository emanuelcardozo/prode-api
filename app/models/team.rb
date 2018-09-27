class Team
  include Mongoid::Document
  field :name, type: String
  field :logo, type: String
  field :status, type: Boolean, default: true

end
