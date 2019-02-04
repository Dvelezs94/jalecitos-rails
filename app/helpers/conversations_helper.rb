module ConversationsHelper
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
        c.sender == current_user ? @users << {'user' => c.recipient, 'unread_messages' => c.unread_messages?(current_user) }   : @users << {'user' => c.sender, 'unread_messages' => c.unread_messages?(current_user) }
    end
  end
end
