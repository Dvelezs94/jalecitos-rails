class Verification < ApplicationRecord
  belongs_to :user
  enum status: { pending: 0, granted: 1, denied: 2 }

  after_commit :verify_user, if: -> { self.status == "granted" }

  def verify_user
    self.user.update(verified: true)
    # Send Email notification to user congratulating them for being verified
  end
end
