module ConversationFunctions
  private
  def set_recipient
    if params[:user_id]
      @remote_user = User.friendly.find(params[:user_id]).id

      if ! @conversation = Conversation.search("*", where: { _or: [{sender_id: current_user.id, recipient_id: @remote_user}, {sender_id: @remote_user ,recipient_id: current_user.id}] }, limit: 1).first
          #  Create conversation if not found. this can be refactored later
          Conversation.create(sender_id: current_user.id, recipient_id: @remote_user)
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

  def filter_conversations
    word = params[:word].downcase
    @my_conversations.each do |c|
      #check if the opposite user alias includes the text, @users is going to be used in partial
      if c.sender_id == current_user.id
        @users << {'user' => c.recipient, 'unread_messages' => c.unread_messages?(current_user)} if c.recipient.alias.downcase.include? word
      else
        @users << {'user' => c.sender, 'unread_messages' => c.unread_messages?(current_user)} if c.sender.alias.downcase.include? word
      end
    end
  end

  def mark_as_read
    # mark current_user messages as read on that conversation
    @unread_messages = @conversation.messages.where(read_at: nil).where.not(user: current_user).update_all(read_at: Time.zone.now)
  end
end
