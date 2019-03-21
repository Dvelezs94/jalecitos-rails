class Conversation < ApplicationRecord
  #search
  # searchkick language: "spanish"

  # def search_data
  #   {
  #     recipient_id: recipient_id,
  #     sender_id: sender_id,
  #     updated_at: updated_at,
  #    }
  # end
  has_many :messages, dependent: :destroy
  belongs_to :sender, foreign_key: :sender_id, class_name: "User"
  belongs_to :recipient, foreign_key: :recipient_id, class_name: "User"

  validates :sender_id, uniqueness: { scope: :recipient_id }

  scope :between, -> (sender_id, recipient_id) do
    where(sender_id: sender_id, recipient_id: recipient_id).or(
      where(sender_id: recipient_id, recipient_id: sender_id)
    )
  end

  scope :mine, -> (user_id) do
    #dont show conversations that doesnt have messages
    where("(sender_id=? OR recipient_id=?) AND (updated_at - created_at > '?')", user_id, user_id, 0.3.second)
  end


  def self.get(sender_id, recipient_id)
    conversation = between(sender_id, recipient_id).first
    return conversation if conversation.present?

    create(sender_id: sender_id, recipient_id: recipient_id)
  end

  def opposed_user(user_id)
    user_id == recipient_id ? sender : recipient
  end

  def participants
    [self.sender.id, self.recipient.id]
  end

  def unread_messages?(user)
    self.messages.select{|m| m.read_at == nil && m.user_id != user.id}.present?
  end
end
