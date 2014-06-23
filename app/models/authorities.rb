class Authorities
  include Mongoid::Document

  field :username, type: String
  field :avatar, type: String

  has_many :repos
end
