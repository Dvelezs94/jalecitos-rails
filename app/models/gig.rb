class Gig < ApplicationRecord
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
  #Associations
  belongs_to :user
  #belongs_to :active_user, { where(:users => { status: "active" }) }, :class_name => "User"

  belongs_to :category
  has_many :packages, ->{ order(id: :asc) }, dependent: :destroy
  has_many :gig_first_pack, ->{ limit(1).order(id: :asc) }, class_name: 'Package'
  has_many :gig_packages, ->{ limit(3).order(id: :asc) }, class_name: 'Package'
  has_many :gigs_packages, ->{ limit(15).order(id: :asc) }, class_name: 'Package'
  has_many :search_gigs_packages, ->{ limit(45).order(id: :asc) }, class_name: 'Package'
  #Validations
  validates_presence_of :name, :description, :location
  validate :maximum_amount_of_tags, :no_spaces_in_tag, :tag_length
  validates_length_of :name, :maximum => 100
  validates_length_of :description, :maximum => 2000
  validate :without_html
  validate :location_syntax
  #Custom fields
  enum status: { draft: 0, published: 1, banned: 2}
  mount_uploader :image, GigUploader

end
