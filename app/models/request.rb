class Request < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :offers
  validates_presence_of :name, :description, :location, :budget, :category_id
  mount_uploader :image, RequestUploader
end
