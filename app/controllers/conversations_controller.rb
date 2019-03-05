class ConversationsController < ApplicationController
  include ReportFunctions
  include ConversationFunctions
  layout 'logged'
  before_action :authenticate_user!
  before_action :set_recipient, only: [:index, :create]
  access user: :all

  # GET /conversations
  def index
    if params[:page]
      @messages = Message.search("*", where: {conversation_id: @conversation.id}, order: [{ _id: { order: :desc, unmapped_type: :long}}], page: params[:page], per_page: 25)
    elsif params[:word]
      @users = []
      @my_conversations = Conversation.search("*", where: {
         _or: [{sender_id: current_user.id}, {recipient_id: current_user.id}]
         })
      filter_conversations
    else
      get_opposite_user(Conversation.search("*", where: { _or: [{sender_id: current_user.id}, {recipient_id: current_user.id}] }, order: [{ updated_at: { order: :desc, unmapped_type: :long}}]) )
      if params[:user_id] && params[:user_id] != current_user.slug
        @messages = Message.search("*", where: {conversation_id: @conversation.id}, order: [{ _id: { order: :desc, unmapped_type: :long}}], page: params[:page], per_page: 25)
        mark_as_read
      end
      report_options
    end
  end

  def create
    @conversation = conversation

    respond_to do |format|
      format.js
    end
  end


  def close
    @conversation = Conversation.find(params[:id])

    session[:conversations].delete(@conversation.id)

    respond_to do |format|
      format.js
    end
  end

  def check_unread
    @conversations = Conversation.search("*", where: { _or: [{sender_id: current_user.id}, {recipient_id: current_user.id}] })
    @unread = false
    @conversations.each do |c|
      if c.unread_messages?(current_user)
        @unread = true
        break
      end
    end
  end

  def read_conversation
    @conversation = Conversation.find(params[:id])
    # mark current_user messages as read on that conversation
    @unread_messages = @conversation.messages.where(read_at: nil).where.not(user: current_user).update_all(read_at: Time.zone.now)
  end

end
