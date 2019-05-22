class Report < ApplicationRecord
  belongs_to :user
  belongs_to :reportable, polymorphic: true
  belongs_to :ban, optional: true
  enum status: { open: 0, closed: 1 }
  enum cause: {offensive: 0, sexual: 1, violence: 2, spam: 3, fraud: 4, other: 5}
  validates :user_id, :uniqueness => { :scope => [:reportable_type, :reportable_id] }
  validates_presence_of :cause
  after_commit -> { BanWorker.perform_async(self.id) }, on: :create

end
