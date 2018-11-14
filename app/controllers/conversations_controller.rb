class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipient, only: [:index, :create]
  layout 'logged'
  access user: :all

  # GET /conversations
  def index
    get_opposite_user(current_user.conversations.order(updated_at: :desc))
    @conversations = Conversation.includes(:recipient, :messages).where("sender_id = ? OR recipient_id = ?", current_user.id, current_user.id)

  end

  def create
    @conversation = conversation

    respond_to do |format|
      format.js
    end
  end

  def mark_as_read
    @conversation = Conversation.find(param[:conversation_id])
    @unread_messages = @conversation.messages.where(read_at: nil)
    @unread_messages.each do |m|
      u.read_at = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      u.save
    end
  end

  def close
    @conversation = Conversation.find(params[:id])

    session[:conversations].delete(@conversation.id)

    respond_to do |format|
      format.js
    end
  end

  private

  def set_recipient
    if params[:user_id]
      @remote_user = User.friendly.find(params[:user_id]).id
      if ! @conversation = Conversation.where("(sender_id = ? OR recipient_id = ?) AND( sender_id = ? OR recipient_id = ?)", current_user.id, current_user.id, @remote_user , @remote_user).first
          #  Create conversation if not found. this can be refactored later
          Conversation.create!(sender_id: current_user.id, recipient_id: @remote_user)
          set_recipient
      end
    else
      @conversation = nil
    end
  end

  def get_opposite_user(conversations)
    @users = []
    conversations.each do |c|
        c.sender == current_user ? @users << c.recipient : @users << c.sender
    end
  end
end
