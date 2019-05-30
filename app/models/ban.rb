class Ban < ApplicationRecord
  belongs_to :baneable, polymorphic: true
  has_many :reports
  #if banned_by is nil, it means system banned. Also if cause is system_ban
  belongs_to :banned_by, :class_name => "User", optional: true
  #if a resource is deleted it cant be unbanned, so if resource is banned and resource is deleted, it use this enum
  enum status: { banned: 0, unbanned: 1, deleted_resource: 2}
  enum cause: {offensive: 0, sexual: 1, violence: 2, spam: 3, fraud: 4, other: 5, system_ban: 6}
  validates_presence_of :cause
  #when create a ban, check if object was already banned...
  validates :baneable_id, :uniqueness => { :scope => [:baneable_type, :status] }, on: :create
  after_validation :ban_the_stuff, on: :create
  after_commit :close_related_reports, on: :create
  before_update :unban_stuff, if: :status_changed?

  private
  def ban_the_stuff
    baneable.banned!
  end

  def unban_stuff
    if status == "unbanned"
      baneable.unban! #unban the resource (the method unban! of each type is in their model )
    end
  end
  def close_related_reports
    reports = Report.where(reportable: baneable, status: "open") #open reports related to this are going to be accepted
    reports.each do |r|
      r.update(ban: self, status: "accepted")
    end
  end
end
