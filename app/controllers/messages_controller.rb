class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_conversation
  skip_before_action :verify_authenticity_token
  before_action :verify_participants

  def create
    message = Message.new(message_params)
    message.user = current_user
    message.conversation = @conversation
    message.save
    @unread_messages = @conversation.messages.where(read_at: nil).where.not(user: current_user).update_all(read_at: Time.zone.now)
  end

  private

  def set_conversation
    @conversation = Conversation.find(params[:conversation_id])
  end

  def message_params
    params.require(:message).permit(:body, :image, :related_to_id, :related_to_type)
  end

  def verify_participants
    if ! @conversation.participants.include? current_user.id
      head :no_content
    end
  end
end
