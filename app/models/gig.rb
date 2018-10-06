class Gig < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_and_belongs_to_many :tags

  validates_presence_of :name, :description, :location

  mount_uploader :image, GigUploader
end
