class Gig < ApplicationRecord
  #includes
  include TagRestrictions
  include DescriptionRestrictions
  include LocationValidation
  #search
  searchkick language: "spanish", word_start: [:name, :description]
  def search_data
    {
      name: no_special_chars(name).downcase,
      #remove html, multi spaces (IS REQUIRED REPLACING THE HTML WITH SPACE) and remove entities (also strip spaces from beginning and end), then remove special chars amd strip (removes leading and trailing spaces) and make it downcase
      description: "#{no_special_chars( decodeHTMLEntities(  no_double_spaces( no_html(description, true) ), false ) ).strip.downcase} #{tag_list.join(" ")}",
      location: location,
      category_id: category_id,
      status: status,
      user_id: user_id
     }
  end
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
  #Gallery validations
  validates :images, length: {
  maximum: 5,
  message: 'no puedes tener más de 5 imágenes'
  }
  #Custom fields
  enum status: { draft: 0, published: 1, banned: 2}
  mount_uploaders :images, GigUploader
  #Actions

end
