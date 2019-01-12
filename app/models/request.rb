class Request < ApplicationRecord
  #includes
  include TagRestrictions
  include DescriptionRestrictions
  include LocationValidation
  #search
  searchkick language: "spanish", word_start: [:name, :description, :tags]
  def search_data
    {
      name: no_special_chars(name).downcase,
      #remove html, multi spaces (IS REQUIRED REPLACING THE HTML WITH SPACE) and remove entities (also strip spaces from beginning and end), then remove special chars amd strip (removes leading and trailing spaces) and make it downcase
      description: "#{no_special_chars( decodeHTMLEntities(  no_double_spaces( no_html(description, true) ), false ) ).strip.downcase} #{tag_list.join(" ")}",
      location: location,
      category_id: category_id,
      status: status,
      user_id: user_id,
      created_at: created_at
     }
  end
  #Tags
  acts_as_taggable
  #Slugs
  extend FriendlyId
  friendly_id :name, use: :slugged
  #Enums
  enum status: { open: 0, in_progress: 1, completed: 2, closed: 3, banned: 4}
  #Associations
  belongs_to :user
  belongs_to :category
  has_many :offers
  belongs_to :employee, class_name: "User", optional: true
  #Validations
  validates_presence_of :name, :description, :location, :budget, :category_id
  validate  :tag_length, :no_spaces_in_tag, :maximum_amount_of_tags
  validates_length_of :name, :maximum => 100, :message => "debe contener como máximo 100 caracteres."
  validate :description_length, :count_without_html
  validate :location_syntax

  #Custom fields
  mount_uploader :image, RequestUploader

  #notify users when new request is made
  after_commit -> { NotifyNewRequestWorker.perform_async(self.id) }, on: :create
end
