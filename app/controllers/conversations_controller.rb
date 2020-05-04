class ConversationsController < ApplicationController

  include ConversationFunctions
  layout 'logged'
  access user: :all
  before_action :check_not_me
  before_action :authenticate_user!
  before_action :set_recipient, only: [:index, :create]

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
        }
        format.js{}
      end

    elsif params[:word]
      @users = []
      get_conversations
      filter_conversations
    else
      respond_to do |format|
        format.html {
          get_conversations
          get_opposite_user( @conversations )
          if params[:user_id] && params[:user_id] != current_user.slug
            get_messages
            mark_as_read
          end
        }
        format.js { #user clicked in a conv_min so i am going to display the conversation
          get_messages
          mark_as_read
        }

      end
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
    @conversations = Conversation.mine(current_user)
    @messages = Message.where(conversation_id: @conversations.pluck(:id)).where.not(user: current_user).order(created_at: :desc).limit(5) #get last 5 messages, i dont care if they were read
    @unread = @messages.select{|msg| msg.read_at == nil }.present? #some of the last 5 messages needs to be read, NOTE: i am just checking last messages, now i dont care if a very old message is unread
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
    @messages = Message.where(conversation_id: @conversation.id).order(id: :desc).page(params[:page]).per(50)
  end

  def check_not_me
    if current_user.id.to_s == params[:user_id]
      flash[:warning] = "No puedes mensajearte a ti mismo"
      redirect_to request.referrer
    end
  end
end
