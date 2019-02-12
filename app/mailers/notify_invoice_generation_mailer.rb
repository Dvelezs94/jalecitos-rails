class NotifyInvoiceGenerationMailer < ApplicationMailer
  def invoice_ready(user, pdf_url, xml_url, order_id)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": user.email
            }
          ],
          "dynamic_template_data": {
            "ALIAS": user.alias,
            "PDF_LINK": pdf_url,
            "XML_LINK": xml_url,
            "ORDER_ID": order_id
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-a429eb88402e4c9fb58c0ada5de294c5"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end
end
