class Report < ApplicationRecord
  belongs_to :user
  belongs_to :reportable, polymorphic: true
  belongs_to :ban, optional: true
  #if report is open and the resource is deleted, the report passes to this enum
  enum status: { open: 0, accepted: 1, denied: 2, deleted_resource: 3 }
  enum cause: {offensive: 0, sexual: 1, violence: 2, spam: 3, fraud: 4, other: 5}
  validates :user_id, :uniqueness => { :scope => [:reportable_type, :reportable_id] }
  validates_presence_of :cause
  after_commit -> { BanWorker.perform_async(self.id) }, on: :create
end
