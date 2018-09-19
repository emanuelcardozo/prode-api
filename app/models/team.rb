class Team
  include Mongoid::Document
  field :name, type: String
  field :logo, type: String
end
