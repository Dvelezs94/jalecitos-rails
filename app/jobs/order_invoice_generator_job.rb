class OrderInvoiceGeneratorJob < ApplicationJob
  require 'net/http'
  queue_as :default

  def perform(order)
    zip_code = 25204
    iva = 0.16
    subtotal = ((order.total/116) * 100).round(2)
    total = order.total
    recipient = {"nombre": "#{order.billing_profile.name}",
                "rfc": "#{order.billing_profile.rfc}",
                "email": "#{order.employer.email}",
                "uso_cfdi": "G03"
                }
    concept = [{"identificador": "Orden #{order.uuid}",
               "cantidad": 1,
               "valor_unitario": subtotal,
               "descripcion": "Servicios profesionales para la orden #{order.uuid}",
               "importe": subtotal,
               "clave": "#{order.id}",
               "clave_unidad": "ACT",
               "traslados": [
                   {
                       "impuesto": "002",
                       "base": subtotal,
                       "tipo_factor": "Tasa",
                       "tasa": iva,
                       "importe": (subtotal * iva).round(2)
                   }
               ]
              }]
      impuestos_traslado =  [{"impuesto": "002",
                              "tasa": iva,
                              "importe": concept[0][:traslados][0][:importe],
                              "tipo_factor": "Tasa"
                            }]
      invoice = {"invoice_id": "#{order.uuid}",
                 "total": order.total,
                 "subtotal": subtotal,
                 "forma_pago": "04",
                 "metodo_pago": "PUE",
                 "lugar_expedicion": "#{zip_code}",
                 "moneda": "MXN",
                 "tipo_de_cambio": 1,
                 "receptor": recipient,
                 "conceptos": concept,
                 "impuestos_traslado": impuestos_traslado
                 }

      # Curl HTTP Call
      openpay_url = ENV.fetch("RAILS_ENV") == "production" ? "api.openpay.mx" : "sandbox-api.openpay.mx"
      uri = URI("https://#{openpay_url}/v1/#{ENV.fetch("OPENPAY_MERCHANT_ID")}/invoices/v33")
      header = {"Content-Type" => "application/json"}
      https = Net::HTTP.new(uri.host,uri.port)
      https.use_ssl = true
      req = Net::HTTP::Post.new(uri.path, header)
      req.basic_auth ENV.fetch("OPENPAY_PRIVATE_KEY"), ''
      req.body = invoice.to_json
      res = https.request(req)
      p res
  end
end
