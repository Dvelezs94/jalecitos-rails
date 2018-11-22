class Dispute < ApplicationRecord
  belongs_to :order
  has_many :replies

  validates_uniqueness_of :order
  mount_uploader :image, DisputeUploader
  enum status: { waiting_for_employee: 0, refunded: 1, proceeded: 2, waiting_for_support: 3, waiting_for_employer: 5}
end
