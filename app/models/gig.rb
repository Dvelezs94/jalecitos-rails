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
  has_many :likes, dependent: :destroy
  belongs_to :category
  has_many :packages, ->{ order(id: :asc) }, dependent: :destroy
  has_many :gig_first_pack, ->{ limit(1).order(id: :asc) }, class_name: 'Package'
  has_many :gig_packages, ->{ limit(3).order(id: :asc) }, class_name: 'Package'
  has_many :gigs_packages, ->{ limit(15).order(id: :asc) }, class_name: 'Package'
  has_many :search_gigs_packages, ->{ limit(60).order(id: :asc) }, class_name: 'Package'
  #Validations
  validates_presence_of :name, :description, :location
  validate :maximum_amount_of_tags, :no_spaces_in_tag, :tag_length
  validates_length_of :name, :maximum => 100, :message => "debe contener como máximo 100 caracteres."
  validate :description_length, :count_without_html
  validate :location_syntax
  validate :check_max_files
  #Custom fields
  enum status: { draft: 0, published: 1, banned: 2}
  mount_uploaders :images, GigUploader
  #Actions
  before_update :erase_s3_img

  def erase_s3_img
    #if the user uploaded new images
    if images.size > 0
      #get the gig to obtain past images
      @gig = Gig.find(self.id)
      #delete each image from s3
      @gig.images.each do |image|
        image.remove!
      end
    end
  end

  def check_max_files
    if images.size > 5
      errors.add(:images, "no deben contener más de 5")
    end
  end

end
