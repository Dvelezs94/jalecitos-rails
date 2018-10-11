class Payment < ApplicationRecord
  belongs_to :package, optional: true
  belongs_to :offer, optional: true
  belongs_to :user
end
