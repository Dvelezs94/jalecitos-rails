class Request < ApplicationRecord
  #includes
  include TagRestrictions
  include DescriptionRestrictions
  include LocationValidation
  #search
  searchkick language: "spanish"
  #Tags
  acts_as_taggable
  #Slugs
  extend FriendlyId
  friendly_id :name, use: :slugged
  #Enums
  enum status: { open: 0, in_progress: 1, completed: 2, closed: 3}
  #Associations
  belongs_to :user
  belongs_to :category
  has_many :offers
  #Validations
  validates_presence_of :name, :description, :location, :budget, :category_id
  validate  :tag_length, :no_spaces_in_tag, :maximum_amount_of_tags
  validates_length_of :name, :maximum => 100, :message => "debe contener como máximo 100 caracteres."
  validates_length_of :description, :maximum => 2000, :message => "contiene demasiados efectos, considera usar más texto plano."
  validate :count_without_html
  validate :location_syntax

  #Custom fields
  mount_uploader :image, RequestUploader
end
