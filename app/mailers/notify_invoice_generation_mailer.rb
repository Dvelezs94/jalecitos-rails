class NotifyInvoiceGenerationMailer < ApplicationMailer
  def invoice_ready(user, pdf_link, xml_link, order_id)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": user.email
            }
          ],
          "dynamic_template_data": {
            "ALIAS": (user.name || user.alias),
            "PDF_LINK": pdf_link,
            "XML_LINK": xml_link,
            "ORDER_ID": order_id
          }
        }
      ],
      "from": {
        "email": "noreply@wandapp.com.mx",
        "name": "Wand"
      },
      "template_id": "d-a429eb88402e4c9fb58c0ada5de294c5"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end
end
