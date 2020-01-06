class Faq < ApplicationRecord
  belongs_to :gig
  validates_presence_of :question, :answer
  validates_length_of :question, :maximum => 200
  validates_length_of :answer, :maximum => 1000

  def question=(val)
    write_attribute(:question, val.strip)
  end

  def answer=(val)
    write_attribute(:answer, val.strip)
  end
end
