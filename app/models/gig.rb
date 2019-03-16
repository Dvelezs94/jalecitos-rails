class Gig < ApplicationRecord
  #includes
  include TagRestrictions
  include LocationFunctions
  include FilterRestrictions
  include GigRequestFunctions
  #search
  searchkick language: "spanish", word_start: [:name, :description, :profession, :tags], suggest: [:name, :description, :profession, :tags]
  def search_data
    {
      name: no_special_chars(name).downcase,
      #remove special chars
      description: no_special_chars(description),
      tags: tag_list.join(" "),
      city_id: city_id,
      category_id: category_id,
      status: status,
      profession: profession,
      user_id: user_id,
      verified: user.verified,
      created_at: created_at,
      updated_at: updated_at,
      order_count: order_count,
      score: score_average * score_times
     }
  end
  #Tags
  acts_as_taggable
  #Slugs
  extend FriendlyId
  friendly_id :name, use: :slugged
  #Associations
  belongs_to :user
  belongs_to :city
  #belongs_to :active_user, { where(:users => { status: "active" }) }, :class_name => "User"
  has_many :likes, dependent: :destroy
  belongs_to :category
  has_many :packages, ->{ order(id: :asc) }, dependent: :destroy
  has_many :gig_first_pack, ->{ limit(1).order(id: :asc) }, class_name: 'Package'
  has_many :gig_packages, ->{ limit(3).order(id: :asc) }, class_name: 'Package'
  has_many :gigs_packages, ->{ limit(45).order(id: :asc) }, class_name: 'Package'
  has_many :query_pack, ->{ limit(60).order(id: :asc) }, class_name: 'Package'
  has_many :prof_pack, ->{ limit(60).order(id: :asc) }, class_name: 'Package'
  has_many :related_pack, ->{ limit(30).order(id: :asc) }, class_name: 'Package'
  #Validations
  validates_presence_of :name, :profession, :description
  validate :maximum_amount_of_tags, :no_spaces_in_tag, :tag_length
  validates_length_of :name, :maximum => 100, :message => "debe contener como máximo 100 caracteres."
  validates_length_of :description, :maximum => 1000, :message => "debe contener como máximo 1000 caracteres."
  validates_length_of :profession, :maximum => 50, :message => "debe contener como máximo 50 caracteres."
  validate :location_validate
  #Gallery validations
  validates :images, length: {
  maximum: 5,
  message: 'no puedes tener más de 5 imágenes'
  }
  #Custom fields
  enum status: { draft: 0, published: 1, banned: 2}
  mount_uploaders :images, GigUploader
  #Actions

  #capitalize before save
  def profession=(val)
    write_attribute(:profession, no_multi_spaces(val.strip.capitalize))
  end
  def description=(val)
    write_attribute(:description, no_multi_spaces(remove_uris(val.strip)))
  end
  def name=(val)
    write_attribute(:name, no_multi_spaces(remove_uris(val.strip)))
  end

  def title
    "Voy a #{to_downcase(self.name)}"
  end
end
