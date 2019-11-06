class RequestMailer < ApplicationMailer
  def new_request(receiver, request)
    @request = request
    @user = User.find(receiver)

    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": @user.email
            }
          ],
          "dynamic_template_data": {
            "ALIAS": @user.alias,
            "TITLE": @request.title,
            "CONTENT": "#{@request.description}",
            "REQUEST_URL": request_url(@request.slug),
            "BUDGET": "#{@request.budget}"
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-82c78cae3a0049d2b556a258a1fee8cd"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end
end
