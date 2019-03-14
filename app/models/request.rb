class Request < ApplicationRecord
  #includes
  include TagRestrictions
  include RequestsHelper
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
      user_id: user_id,
      profession: profession,
      created_at: created_at
     }
  end
  #Tags
  acts_as_taggable
  #Slugs
  extend FriendlyId
  friendly_id :name, use: :slugged
  #Enums
  enum status: { published: 0, in_progress: 1, completed: 2, closed: 3, banned: 4}
  #Associations
  belongs_to :user
  belongs_to :category
  belongs_to :city
  has_many :offers, dependent: :destroy
  belongs_to :employee, class_name: "User", optional: true
  #Validations
  validates_presence_of :name, :description, :budget, :category_id, :profession
  validate  :tag_length, :no_spaces_in_tag, :maximum_amount_of_tags
  validates_length_of :name, :maximum => 100, :message => "debe contener como máximo 100 caracteres."
  validates_length_of :profession, :maximum => 50, :message => "debe contener como máximo 50 caracteres."
  validates_length_of :description, :maximum => 1000, :message => "debe contener como máximo 1000 caracteres."

  validate :location_validate
  validate :budget_options

  #Custom fields
  mount_uploader :image, RequestUploader

  #notify users when new request is made
  after_commit -> { NotifyNewRequestWorker.perform_async(self.id) }, on: :create

  #Actions
  #capitalize before save
  def profession=(val)
    write_attribute(:profession, no_multi_spaces(val.strip.capitalize))
  end

  def description=(val)
    write_attribute(:description, no_multi_spaces(val.strip))
  end

  def title
    "Busco un #{to_downcase(self.profession)} #{to_downcase(self.name)}"
  end

  def budget_options
    if ! options_for_budget.include?(self.budget)
      errors.add(:base, "No seleccionaste un presupuesto válido.")
    end
  end
end
