class TicketMailer < ApplicationMailer
  def support_responded(response)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": response.ticket.user.email
            }
          ],
          "dynamic_template_data": {
            "ALIAS": response.ticket.user.alias,
            "TICKET_TITLE": response.ticket.title,
            "TICKET_URL": ticket_url(response.ticket.slug),
            "TICKET_RESPONSE_MESSAGE": response.message
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-4fde3f09539e463aae4c7ef480d1c3b4"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end

  def user_responded(response)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": "soporte@jalecitos.com"
            }
          ],
          "dynamic_template_data": {
            "ALIAS": response.ticket.user.alias,
            "TICKET_TITLE": response.ticket.title,
            "TICKET_URL": ticket_url(response.ticket.slug),
            "TICKET_RESPONSE_MESSAGE": response.message
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-bfc359a568fd46d284fce9cce0b8c6f3"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end
end
