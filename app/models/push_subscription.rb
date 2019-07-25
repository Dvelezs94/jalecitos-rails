class PushSubscription < ApplicationRecord
  belongs_to :user
  validates_presence_of :auth_key
  validates_uniqueness_of :auth_key

  after_create :purge_old_subscriptions

  private
  # Destroy other push subscriptions that dont belong to the mobile device
  def purge_old_subscriptions
      token = self.auth_key
      self.user.push_subscriptions.where.not(auth_key: token, device: "mobile").destroy_all if self.device == "mobile"
  end
end
