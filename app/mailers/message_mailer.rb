class MessageMailer < ApplicationMailer
  def new_message(message)
    @message = message

    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": @message.conversation.opposed_user(@message.user).email
            }
          ],
          "dynamic_template_data": {
            "MSG_ALIAS": @message.user.alias,
            "MSG_CONTENT": @message.body,
            "CONVERSATION_URL": conversations_url(user_id: @message.user.slug)
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-f74e56ed150f4d17b0c0196e4ccc3f0d"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end
end
