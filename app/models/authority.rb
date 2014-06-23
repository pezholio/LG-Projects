class Authority
  include Mongoid::Document

  field :username, type: String
  field :name, type: String
  field :avatar, type: String

  has_many :repos
end
