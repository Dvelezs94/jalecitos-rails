class Verification < ApplicationRecord
  belongs_to :user

  validates_presence_of :identification, :curp, :address, :criminal_letter

  enum status: { pending: 0, granted: 1, denied: 2 }
  mount_uploaders :identification, VerificationUploader
  mount_uploader :address, VerificationUploader
  mount_uploader :criminal_letter, VerificationUploader

  after_commit :verify_user, if: -> { self.status == "granted" }
  after_commit :notify_denial, if: -> { self.status == "denied" }

  #validations
  validates :identification, length: {
    maximum: 2,
    message: 'debe tener como máximo dos fotos'
  }
  #functions

  def verify_user
    self.user.update(verified: true)
    # Send Email notification to user congratulating them for being verified
    VerificationMailer.approved(self).deliver
  end

  def notify_denial
    #send email to user notifying that the verification has been denied
    VerificationMailer.denied(self).deliver
  end
end
