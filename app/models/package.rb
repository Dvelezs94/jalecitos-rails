class Package < ApplicationRecord
  #Associations
  belongs_to :gig
  #Custom fields
  enum pack_type: { basic: 0, standard: 1, premium: 2}
end
