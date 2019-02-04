class ConversationsController < ApplicationController
  include ReportFunctions
  include ConversationsHelper
  layout 'logged'
  before_action :authenticate_user!
  before_action :set_recipient, only: [:index, :create]
  access user: :all

  # GET /conversations
  def index
    get_opposite_user(current_user.conversations.order(updated_at: :desc))
    # @conversations = Conversation.includes(:recipient, :messages).where("sender_id = ? OR recipient_id = ?", current_user.id, current_user.id)
    if params[:user_id] && params[:user_id] != current_user.slug
      @messages = Message.search("*", where: {conversation_id: @conversation.id}, order: [{ id: { order: :desc, unmapped_type: :long}}], page: params[:page], per_page: 25)
      mark_as_read
    end
    report_options
  end

  def create
    @conversation = conversation

    respond_to do |format|
      format.js
    end
  end

  def mark_as_read
    # mark current_user messages as read on that conversation
    @unread_messages = @conversation.messages.where(read_at: nil).where.not(user: current_user).update_all(read_at: Time.zone.now)
  end

  def close
    @conversation = Conversation.find(params[:id])

    session[:conversations].delete(@conversation.id)

    respond_to do |format|
      format.js
    end
  end

end
