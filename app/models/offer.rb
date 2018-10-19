class Offer < ApplicationRecord
  belongs_to :user
  belongs_to :request
  has_one :payment

  after_create :new_offer_email

  def new_offer_email
    OfferMailer.new_offer(self)
  end
end
