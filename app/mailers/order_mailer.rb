class OrderMailer < ApplicationMailer
  def error_worker(order_id)
    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": "support@jalecitos.com"
            }
          ],
          "bcc": [
            {
              "email": "jalecitos.mails@gmail.com"
            }
          ],
          "dynamic_template_data": {
            "ORDER_ID": order_id
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-506e9eadc66b4d518efc64f061d365af"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end

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
            "GIG_URL": gig_url(@order.purchase.gig),
            "GIG_NAME": @order.purchase.gig.title,
            "EMPLOYER": @order.employer.alias,
            "EMPLOYEE": @order.employee.alias,
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
            "GIG_URL": gig_url(@order.purchase.gig),
            "GIG_NAME": @order.purchase.gig.title,
            "EMPLOYER": @order.employer.alias,
            "EMPLOYEE": @order.employee.alias,
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
            "EMPLOYER": @order.employer.alias,
            "EMPLOYEE": @order.employee.alias,
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
            "EMPLOYER": @order.employer.alias,
            "EMPLOYEE": @order.employee.alias,
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

  def order_started(order)
    @order = order

    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": @order.employer.email
            }
          ],
          "dynamic_template_data": {
            "EMPLOYER": @order.employer.alias,
            "EMPLOYEE": @order.employee.alias,
            "ORDER_ID": @order.uuid
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-c2a12c29f7494f09a2c5a63f5a01440c"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end

  def order_request_finish(order)
    @order = order

    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": @order.employer.email
            }
          ],
          "dynamic_template_data": {
            "EMPLOYER": @order.employer.alias,
            "EMPLOYEE": @order.employee.alias,
            "ORDER_ID": @order.uuid
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-dc6a5e483f424ee7a867e5e0e8b3d48b"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end

  def order_finished(order)
    @order = order

    data = {
      "personalizations": [
        {
          "to": [
            {
              "email": @order.employee.email
            }
          ],
          "dynamic_template_data": {
            "EMPLOYER": @order.employer.alias,
            "EMPLOYEE": @order.employee.alias,
            "ORDER_ID": @order.uuid
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-8570d6c13aef4ce1a538ae43a524cb99"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end

  def completed_after_72_hours(order)
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
            "ALIAS": @order.employer.alias,
            "ORDER_ID": @order.uuid
          }
        }
      ],
      "from": {
        "email": "noreply@jalecitos.com",
        "name": "Jalecitos"
      },
      "template_id": "d-b4c1b012e85047de86d61c8f189894e6"
    }

    sendgrid_client.client.mail._("send").post(request_body: (data))
  end
end
