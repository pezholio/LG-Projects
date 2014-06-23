class Authority
  include Mongoid::Document
  include Mongoid::Slug

  field :username, type: String
  field :name, type: String
  field :avatar, type: String

  has_many :repos
  slug :username
end
