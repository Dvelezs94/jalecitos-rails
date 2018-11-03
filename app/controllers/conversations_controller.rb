class ConversationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recipient, only: [:index, :create]
  layout 'logged'
  access user: :all

  # GET /conversations
  def index
    @users = User.all.where.not(id: current_user)
    @conversations = Conversation.includes(:recipient, :messages).where("sender_id = ? OR recipient_id = ?", current_user.id, current_user.id)

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
end
