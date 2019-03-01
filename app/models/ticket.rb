class Ticket < ApplicationRecord
  extend FriendlyId
  mount_uploaders :images, TicketUploader
  friendly_id :title, use: :slugged
  belongs_to :user
  has_many :ticket_responses
  enum status: { in_progress: 0, resolved: 1}
  enum priority: { low: 0, normal: 1, high: 2}
  enum turn: { waiting_for_support: 0, waiting_for_user: 1}
  #validations
  validates_presence_of :title, :description, :priority
  validates_length_of :title, :maximum => 100, :message => "debe contener como máximo 100 caracteres."
  validates_length_of :description, :maximum => 1000, :message => "debe contener como máximo 1000 caracteres."
  validates :images, length: {
    maximum: 5,
    message: 'no puedes tener más de 5 imágenes'
  }
end
