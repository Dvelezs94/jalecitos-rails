App.conversation = App.cable.subscriptions.create("ConversationChannel", {
  connected: function() {},
  disconnected: function() {},
  received: function(data) {
    var conv_min = $("#"+data['opposite_slug']).closest("a")
    var conversation = $('#conversation-list').find("[data-conversation-id='" + data['conversation_id'] + "']");

    //if i am filtering, i cant append new conversations to filter results...
    if ($("#filter-conversation").val() == "") {

      // if the conversation is visible, remove it and prepend the updated conversation to the start, this wont affect pagination
      if (conv_min.length > 0) {
          conv_min.remove();
          $("#contacts-list").prepend(data['conversation_min']);
      }
      //conversation is not in the current conversations and pagination is present: prepend it and delete the last conversation, so the pagination dont break
      else if ($('#conversation-list').find(".pag-and-load").length > 0) {
        $("#contacts-list")[0].children[$("#contacts-list")[0].children.length - 2].remove() //last is paginator, so -2
        $("#contacts-list").prepend(data['conversation_min']);
      }
      //seems like its a brand new conversation and pagination isnt present, just prepend it
      else {
        $("#contacts-list").prepend(data['conversation_min']);
      }
    }
    if (conversation.length == 0){ // if i am not inside the conversation add the dot
      $(".mess-icon").addClass("unread");
    }
    else {
      conversation.find('.messages-list').append(data['message']);
      var messages_list = conversation.find('.messages-list');
      var height = messages_list[0].scrollHeight;
      $('.message_view_box').scrollTop(height);
      //mark as read if the receiver of message is watching conversation at the time the message arrives
      window.conversations.readConversation(data['conversation_id']);
    }
  }
});
