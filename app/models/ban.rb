class Ban < ApplicationRecord
  belongs_to :baneable, polymorphic: true
  has_many :reports
  enum status: { banned: 0, unbanned: 1}
  enum cause: {offensive: 0, sexual: 1, violence: 2, spam: 3, fraud: 4, other: 5}
  validates_presence_of :cause
  validates_uniqueness_of :baneable_id, :scope => [:baneable_type, :baneable_id]

  after_validation :ban_the_stuff, on: :create

  private
  def ban_the_stuff
    baneable.banned!
  end
end
