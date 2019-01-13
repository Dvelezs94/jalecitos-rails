class Verification < ApplicationRecord
  belongs_to :user
  enum status: { pending: 0, granted: 1, denied: 2 }
  mount_uploader :identification, VerificationUploader
  mount_uploader :address, VerificationUploader
  mount_uploader :criminal_letter, VerificationUploader

  after_commit :verify_user, if: -> { self.status == "granted" }
  after_commit :notify_denial, if: -> { self.status == "denied" }

  def verify_user
    self.user.update(verified: true)
    # Send Email notification to user congratulating them for being verified
  end

  def notify_denial
    #send email to user notifying that the verification has been denied
  end
end
