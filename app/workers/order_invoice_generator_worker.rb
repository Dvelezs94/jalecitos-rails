class OrderInvoiceGeneratorWorker
  include Sidekiq::Worker
  sidekiq_options retry: false, dead: false
  include ApplicationHelper
  require 'net/http'

  def perform(order_id)
    order = Order.find(order_id)
    zip_code = 25204
    subtotal = (order.purchase.price).round(2)
    total = order.total
    recipient = {"nombre": "#{order.billing_profile.name}",
                "rfc": "#{order.billing_profile.rfc}",
                "email": "#{order.employer.email}",
                "uso_cfdi": "G03"
                }
    concept = [{"identificador": "Orden #{order.uuid}",
               "cantidad": 1,
               "unidad": "Orden",
               "valor_unitario": subtotal + base_earning,
               "descripcion": "Servicios profesionales para la orden #{order.uuid}",
               "importe": subtotal + base_earning,
               "clave": "80141600",
               "clave_unidad": "E48",
               "traslados": [
                   {
                       "impuesto": "002",
                       "base": subtotal + base_earning,
                       "tipo_factor": "Tasa",
                       "tasa": iva,
                       "importe": (order_tax(subtotal)
                   }
               ]
              }]
      impuestos_traslado =  [{"impuesto": "002",
                              "tasa": iva,
                              "importe": concept[0][:traslados][0][:importe],
                              "tipo_factor": "Tasa"
                            }]
      invoice = {"invoice_id": "#{order.uuid}",
                 "total": total,
                 "subtotal": subtotal + base_earning,
                 "forma_pago": "04",
                 "hide_total_items": true,
                 "hide_total_taxes": true,
                 "metodo_pago": "PUE",
                 "lugar_expedicion": "#{zip_code}",
                 "moneda": "MXN",
                 "tipo_de_cambio": 1,
                 "receptor": recipient,
                 "conceptos": concept,
                 "impuestos_traslado": impuestos_traslado,
                 "total_trasladados": concept[0][:traslados][0][:importe]
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
  end
end
