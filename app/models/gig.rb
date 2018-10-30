class Gig < ApplicationRecord
  #includes
  include TagRestrictions
  #search
  searchkick
  #Tags
  acts_as_taggable
  #Slugs
  extend FriendlyId
  friendly_id :name, use: :slugged
  #Associations
  belongs_to :user
  #belongs_to :active_user, { where(:users => { status: "active" }) }, :class_name => "User"

  belongs_to :category
  has_many :packages, dependent: :destroy
  has_many :gig_first_pack, ->{ limit(1) }, class_name: 'Package'
  has_many :gig_packages, ->{ limit(3).order(id: :asc) }, class_name: 'Package'
  has_many :gigs_packages, ->{ limit(15).order(id: :asc) }, class_name: 'Package'
  #Validations
  validates_presence_of :name, :description, :location
  validate :maximum_amount_of_tags
  validates_length_of :name, :maximum => 100
  validates_length_of :description, :maximum => 1000
  #Custom fields
  enum status: { draft: 0, published: 1, banned: 2}
  mount_uploader :image, GigUploader
end
