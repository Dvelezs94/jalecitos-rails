class Package < ApplicationRecord
  belongs_to :gig

  enum pack_type: { basic: 0, standard: 1, premium: 2}
end
