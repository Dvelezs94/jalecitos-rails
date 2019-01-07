class BillingProfile < ApplicationRecord
  enum status: { enabled: 0, disabled: 1}
  belongs_to :user
end
