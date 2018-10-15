class Request < ApplicationRecord
  #Slugs
  extend FriendlyId
  friendly_id :name, use: :slugged
  #Associations
  belongs_to :user
  belongs_to :category
  has_many :offers
  #Validations
  validates_presence_of :name, :description, :location, :budget, :category_id
  #Custom fields
  mount_uploader :image, RequestUploader
end
