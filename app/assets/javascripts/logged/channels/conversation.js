App.conversation = App.cable.subscriptions.create("ConversationChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    var conv_min = $("#"+data['opposite_slug'])
    var conversation = $('#conversation-list').find("[data-conversation-id='" + data['conversation_id'] + "']");

    if (conversation.length == 0){ // if i am not inside the conversation add the dot
      $(".mess-icon").addClass("unread");
    }
    //change color of conversation if you are in index
    if (conv_min) {
      console.log(data['opposite_slug']);
      $("#"+data['opposite_slug']).find(".chat-single-box").removeClass("ef");
    }
    if (conversation.length > 0){
      conversation.find('.messages-list').append(data['message']);
      var messages_list = conversation.find('.messages-list');
      var height = messages_list[0].scrollHeight;
      $('.message_view_box').scrollTop(height);
      //mark as read if the receiver of message is watching conversation at the time the message arrives
      window.conversations.readConversation(data['conversation_id']);
    }
  }
});
