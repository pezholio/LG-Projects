class Repo
  include Mongoid::Document

  field :name, type: String
  field :description, type: String
  field :url, type: String
  field :civic_present?, type: Boolean
  field :thumbnail, type: String
  field :status, type: String
  field :owner, type: Hash
  field :deployments, type: Array
  field :service_categories, type: Array
  field :technologies, type: Array

  belongs_to :authority
end
