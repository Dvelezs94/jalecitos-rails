class Ban < ApplicationRecord
  belongs_to :baneable, polymorphic: true
  has_many :reports
  enum status: { banned: 0, unbanned: 1}
  enum cause: {offensive: 0, sexual: 1, violence: 2, spam: 3, fraud: 4, other: 5}
  validates_presence_of :cause
  after_validation :ban_the_stuff, on: :create
  after_validation :close_related_reports, on: :create

  private
  def ban_the_stuff
    baneable.banned!
  end
  def close_related_reports
    reports = Report.where(reportable: baneable, status: "open") #open reports related to this are going to be accepted
    reports.each do |r|
      r.accepted!
    end
  end
end
