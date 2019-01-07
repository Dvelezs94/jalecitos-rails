class OrderMailer < ApplicationMailer
  def new_gig_order_to_employee(order)
    @order = order

    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": @order.employee.email
            }
          ],
          "bcc": [
            {
              "email": "jalecitos.mails@gmail.com"
            }
          ],
          "dynamic_template_data": {
            "GIG_URL": user_gig_url(@order.purchase.gig.user, @order.purchase.gig),
            "GIG_NAME": @order.purchase.gig.name,
            "EMPLOYER": @order.employer.slug,
            "EMPLOYEE": @order.employee.slug,
            "TRANSACTION_URL": finance_url(:table => "sales"),
            "PACKAGE": @order.purchase.pack_type
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-af72ef499d514d58ae35d2ee5a587ae2"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end

  def new_gig_order_to_employer(order)
    @order = order

    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": @order.employer.email
            }
          ],
          "bcc": [
            {
              "email": "jalecitos.mails@gmail.com"
            }
          ],
          "dynamic_template_data": {
            "GIG_URL": user_gig_url(@order.purchase.gig.user, @order.purchase.gig),
            "GIG_NAME": @order.purchase.gig.name,
            "EMPLOYER": @order.employer.slug,
            "EMPLOYEE": @order.employee.slug,
            "PACKAGE": @order.purchase.pack_type,
            "PACKAGE_DESCRIPTION": @order.purchase.description,
            "TOTAL":  @order.total
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-de81dcb50898496fbd493ae667671a84"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end

  def new_request_order_to_employee(order)
    @order = order

    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": @order.employee.email
            }
          ],
          "bcc": [
            {
              "email": "jalecitos.mails@gmail.com"
            }
          ],
          "dynamic_template_data": {
            "REQUEST_URL": request_url(@order.purchase.request.slug),
            "REQUEST_NAME": @order.purchase.request.name,
            "REQUEST_INFORMATION": @order.purchase.request.description,
            "EMPLOYER": @order.employer.slug,
            "EMPLOYEE": @order.employee.slug,
            "TRANSACTION_URL": finance_url(:table => "purchases"),
            "OFFER_TOTAL":  @order.purchase.price
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-bed1e792ddb44a49ab68c5dec5d429e7"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end

  def new_request_order_to_employer(order)
    @order = order

    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": @order.employer.email
            }
          ],
          "bcc": [
            {
              "email": "jalecitos.mails@gmail.com"
            }
          ],
          "dynamic_template_data": {
            "REQUEST_URL": request_url(@order.purchase.request.slug),
            "REQUEST_NAME": @order.purchase.request.name,
            "EMPLOYER": @order.employer.slug,
            "EMPLOYEE": @order.employee.slug,
            "OFFER_DESCRIPTION": @order.purchase.description,
            "TOTAL":  @order.total
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-958c8e1758c949538a8151829672f264"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end
end
