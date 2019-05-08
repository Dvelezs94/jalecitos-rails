class TicketResponse < ApplicationRecord
  belongs_to :ticket
  belongs_to :user
  mount_uploader :image, TicketUploader
  validates_presence_of :message, :unless => :image?
  validates_length_of :message, :maximum => 1000, :message => "debe contener como máximo 1000 caracteres."

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
    if self.user.has_role?(:admin)
      TicketMailer.support_responded(self).deliver
    else
      TicketMailer.user_responded(self).deliver
    end
  end
end
