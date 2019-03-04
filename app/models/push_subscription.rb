class PushSubscription < ApplicationRecord
  belongs_to :user
  validates_presence_of :auth_key
  validates_uniqueness_of :auth_key
end
