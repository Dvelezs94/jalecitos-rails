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
      get_messages
    elsif params[:conversation] || params[:word] == ""
      get_conversations
      get_opposite_user( @conversations )
      respond_to do |format|
        format.html { # if an user clicks in pagination
          if params[:user_id] && params[:user_id] != current_user.slug
            get_messages
            mark_as_read
          end
          report_options
        }
        format.js{}
      end

    elsif params[:word]
      @users = []
      get_conversations
      filter_conversations
    else
      get_conversations
      get_opposite_user( @conversations )
      if params[:user_id] && params[:user_id] != current_user.slug
        get_messages
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
    @conversations = Conversation.includes(:messages).
    mine(current_user)
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

  private
  def get_conversations
    if params[:word].present? #need all conversations
      @all_conversations = Conversation.includes(:sender, :recipient, :messages).
      mine(current_user.id).
      order(updated_at: :desc)
    else #paginated conversations
      @conversations = Conversation.includes(:sender, :recipient, :messages)
      .mine(current_user.id).order(updated_at: :desc).
      page(params[:conversation]).per(20)
    end
  end

  def get_messages
    @messages = Message.where(conversation_id: @conversation.id).order(id: :desc).page(params[:page]).per(25)
  end

end
