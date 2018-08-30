class Payment < ApplicationRecord
  belongs_to :package
  belongs_to :user
end
