class BillingProfile < ApplicationRecord
  enum status: { enabled: 0, disabled: 1}
  belongs_to :user
  has_many :orders

  validates_presence_of :rfc, :name
end
