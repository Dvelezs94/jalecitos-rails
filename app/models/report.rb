class Report < ApplicationRecord
  belongs_to :user
  belongs_to :reportable, polymorphic: true
  belongs_to :ban, optional: true
  #if report is open and the resource is deleted, the report passes to this enum
  #finished resource is used when a request finishes, no sense of ban it
  enum status: { open: 0, accepted: 1, denied: 2, deleted_resource: 3, finished_resource: 4  }
  enum cause: {offensive: 0, sexual: 1, violence: 2, spam: 3, fraud: 4, other: 5}
  #a user can report again a resource if it is unbanned
  validates :user_id, :uniqueness => { :scope => [:reportable_type, :reportable_id, :status] }, on: :create
  validates_presence_of :cause
  after_commit -> { BanWorker.perform_async(self.id) }, on: :create
end
