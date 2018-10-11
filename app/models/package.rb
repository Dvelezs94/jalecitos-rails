class Package < ApplicationRecord
  belongs_to :gig



  def check_for_existence
    self.attr.each do |attr|
      return true if self[attr].nil?
    end
  end
  enum pack_type: { basic: 0, standard: 1, premium: 2}
end
