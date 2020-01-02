class Faq < ApplicationRecord
  belongs_to :gig
  validates_presence_of :question, :answer
end
