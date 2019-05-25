class Ban < ApplicationRecord
  belongs_to :baneable, polymorphic: true
  has_many :reports
  #if a resource is deleted it cant be unbanned, so if resource is banned and resource is deleted, it use this enum
  enum status: { banned: 0, unbanned: 1, deleted_resource: 2}
  enum cause: {offensive: 0, sexual: 1, violence: 2, spam: 3, fraud: 4, other: 5, system_ban: 6}
  validates_presence_of :cause
  #this means: when creating a ban the default status is banned, so this scope tries to find a record banned and with the object baneable, if finds it.. it means the object was already banned and gives error "status is already used"
  #in other words, 1 ban for each object
  validates :status, :uniqueness => { :scope => [:baneable_type, :baneable_id] }
  after_validation :ban_the_stuff, on: :create
  after_commit :close_related_reports, on: :create

  private
  def ban_the_stuff
    baneable.banned!
  end
  def close_related_reports
    reports = Report.where(reportable: baneable, status: "open") #open reports related to this are going to be accepted
    reports.each do |r|
      r.update(ban: self, status: "accepted")
    end
  end
end
