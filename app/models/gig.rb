class Gig < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_and_belongs_to_many :tags

  validates_presence_of :name, :description, :location

  has_many :packages, -> {limit(3)}, class_name: "Package"

  enum status: { draft: 0, published: 1, banned: 2}

  mount_uploader :image, GigUploader

end
