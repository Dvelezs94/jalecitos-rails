class Request < ApplicationRecord
  #includes
  include TagRestrictions
  #Tags
  acts_as_taggable
  #Slugs
  extend FriendlyId
  friendly_id :name, use: :slugged
  #Associations
  belongs_to :user
  belongs_to :category
  has_many :offers
  #Validations
  validates_presence_of :name, :description, :location, :budget, :category_id
  validate :maximum_amount_of_tags
  #Custom fields
  mount_uploader :image, RequestUploader
end
