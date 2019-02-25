class TicketResponse < ApplicationRecord
  belongs_to :ticket
  belongs_to :user

  after_commit -> { [update_ticket_turn, support_email] }, on: :create
  private
  def update_ticket_turn
    if self.user.has_role?(:admin)
      self.ticket.waiting_for_user!
    else
      self.ticket.waiting_for_support!
    end
  end

  def support_email
    TicketMailer.support_responded(self).deliver if self.user.has_role?(:admin)
  end
end