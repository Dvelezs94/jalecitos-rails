class MessageMailer < ApplicationMailer
  def new_message(message, receiver)
    @message = message

    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": receiver
            }
          ],
          "dynamic_template_data": {
            "ALIAS": @message.conversation.opposed_user(@message.user.id).alias,
            "MSG_ALIAS": @message.user.alias,
            "MSG_CONTENT": @message.body,
            "CONVERSATION_URL": conversations_url(user_id: @message.user.id)
          }
        }
      ],
      "from": {
        "email": "noreply@wandapp.com.mx",
        "name": "Wand"
      },
      "template_id": "d-f74e56ed150f4d17b0c0196e4ccc3f0d"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end
end
