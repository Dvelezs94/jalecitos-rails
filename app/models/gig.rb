class Gig < ApplicationRecord
  #Tags
  acts_as_taggable
  #Slugs
  extend FriendlyId
  friendly_id :name, use: :slugged
  #Associations
  belongs_to :user
  belongs_to :category
  has_many :packages, -> {limit(3)}, class_name: "Package", dependent: :destroy
  #Validations
  validates_presence_of :name, :description, :location
  #Custom fields
  enum status: { draft: 0, published: 1, banned: 2}
  mount_uploader :image, GigUploader

end
