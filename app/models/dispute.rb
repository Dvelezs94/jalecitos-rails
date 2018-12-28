class Dispute < ApplicationRecord
  belongs_to :order
  has_many :replies, dependent: :delete_all

  validates_uniqueness_of :order
  mount_uploader :image, DisputeUploader
  enum status: { waiting_for_support: 0, waiting_for_employee: 1, waiting_for_employer: 2, refunded: 3, proceeded: 4}

  def employee
    self.order.employee
  end

  def employer
    self.order.employer
  end
end
