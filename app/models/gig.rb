class Gig < ApplicationRecord
  #includes
  include TagRestrictions
  include LocationFunctions
  include FilterRestrictions
  include GigRequestFunctions
  include BeforeDestroyFunctions
  include LinksHelper
  require 'voight_kampff'
  #search
  searchkick language: "spanish", word_start: [:name, :description, :profession, :tags], suggest: [:name, :description, :profession, :tags]
  def search_data
    {
      #always first remove emojis and then special chars, otherwise there will be rare bugs with symbols inside string when sending to searchkick
      name: no_multi_spaces(remove_nexus(I18n.transliterate(no_special_chars(RemoveEmoji::Sanitize.call(name)).downcase))).strip,
      description: no_multi_spaces(remove_nexus(I18n.transliterate(no_special_chars(RemoveEmoji::Sanitize.call(description)).downcase))).strip,
      tags: tag_list.join(" "),
      city_id: city_id,
      state_id: (city_id.present?)? city.state_id : nil,
      category_id: category_id,
      status: status,
      profession: profession,
      user_id: user_id,
      created_at: created_at,
      updated_at: updated_at,
      #order_count: order_count,
      #verified: user.verified,
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
  belongs_to :city, optional: true
  #belongs_to :active_user, { where(:users => { status: "active" }) }, :class_name => "User"
  has_many :likes, dependent: :destroy

  has_many :completed_reviews, -> (gig) { includes(:gig_rating, :giver).where(receiver_id: gig.user_id, status: "completed").order(updated_at: :desc) }, class_name: 'Review', as: :reviewable

  has_many :faqs, inverse_of: :gig, dependent: :destroy #inverse of allow to save faqs at same time of creating gig (see cocoon gem guide)
  accepts_nested_attributes_for :faqs,allow_destroy: true, limit: 10 #worst case (deleted 5 and sending 5 new in update) so the hash would be 10 items size
  belongs_to :category
  has_many :packages, ->{ order(id: :asc) }, dependent: :destroy
  # has_many :gig_first_pack, ->{ limit(1).order(id: :asc) }, class_name: 'Package' # this is useless (used in toggle icon of show ant toggle status function, but nonsense)
  has_many :gig_packages, ->{ limit(3).order(id: :asc) }, class_name: 'Package'
  #has_many :gigs_packages, ->{ limit(45).order(id: :asc) }, class_name: 'Package' #this was used in carousels but now i keep first package price on gig object, so i dont need grab packages when load preview of slider
  #has_many :query_pack, ->{ limit(60).order(id: :asc) }, class_name: 'Package' #this was used on queries, but now i  dont need packages because i keep since price in gig
  #has_many :prof_pack, ->{ limit(60).order(id: :asc) }, class_name: 'Package'  #this was used on profile, but now i  dont need packages because i keep since price in gig
  has_many :related_pack, ->{ limit(30).order(id: :asc) }, class_name: 'Package'
  #Validations
  validates_presence_of :name, :profession, :description
  validate :maximum_amount_of_tags, :no_spaces_in_tag, :tag_length
  validates_length_of :name, :maximum => 100, :message => "debe contener como máximo 100 caracteres."
  validates_length_of :description, :maximum => 1000, :message => "debe contener como máximo 1000 caracteres."
  validates_length_of :profession, :maximum => 50, :message => "debe contener como máximo 50 caracteres."
  validates_length_of :youtube_url, :maximum => 250, :message => "debe contener como máximo 250 caracteres." #this message doesnt get shown, i didnt displayed it
  validate :location_validate
  #Gallery validations
  validates :images, length: {
  maximum: 5,
  message: 'no puedes tener más de 5 elementos'
  }
  before_destroy :mark_reports_and_bans
  #Custom fields
  enum status: { draft: 0, published: 1, banned: 2, wizard: 3}
  mount_uploaders :images, GigUploader
  #Actions

  #capitalize before save
  def profession=(val)
    write_attribute(:profession, no_multi_spaces(val.strip.capitalize))
  end
  def description=(val)
    write_attribute(:description, no_multi_spaces(val.strip)) #ActionController::Base.helpers.sanitize for sanitize, but i didnt used it because in view i escape all the html and then add the links and now html_safe, so the html from user doesnt work
  end
  def name=(val)
    write_attribute(:name, no_multi_spaces(val.strip))
  end

  def title
    "Ofrezco #{to_downcase(self.name)}"
  end
  def safe_description
    make_links(CGI::escapeHTML(self.description)).html_safe #escapes html from user and make our links
  end

  def safe_title
    make_links(CGI::escapeHTML(title)).html_safe #escapes html from user and make our links
  end

  def min_title #used in miniatures of gigs
    title = self.name
    title[0] = title[0].upcase # make upcase first char
    title
  end

  def tags_content #useful for use eager loading (i eager load :tags and then get the names) because tag_list cand be eager loaded
    self.tags.collect { |t| t.name }
  end

  def punch(request = nil)
    if request.try(:bot?)
      true
    else
      self.increment!(:visits)
    end
  end

  def unban!
    self.update(status: "draft")
  end
  private
  # def should_generate_new_friendly_id? #this is used to change url every time name if changed, its not used now because problems of google indexing pages
  #   name_changed?
  # end
end
