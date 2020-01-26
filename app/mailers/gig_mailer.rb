class GigMailer < ApplicationMailer
  include ApplicationHelper
  def need_indexing(gig)
    gig_new_url = the_gig_url(gig)
    admins = [
      "mauriciovelsa99@gmail.com",
      "velez.guillermo93@gmail.com"
    ]
    admins.each do |admin|
      data = {
        "personalizations": [
          {
            "to": [
              {
                 "email": admin,

              }
            ],
            "dynamic_template_data": {
              "CONTENT": "#{gig_new_url}"
            }
          }
        ],
        "from": {
          "email": "noreply@jalecitos.com",
          "name": "Jalecitos"
        },
        "template_id": "d-f16f50d328b04c1a8f6e7198e6998ad6"
      }

      sendgrid_client.client.mail._("send").post(request_body: (data))
    end
  end
end
