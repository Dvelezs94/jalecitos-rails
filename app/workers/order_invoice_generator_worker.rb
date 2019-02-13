class OrderInvoiceGeneratorWorker
  include Sidekiq::Worker
  include ApplicationHelper
  require 'net/http'

  def perform(order_id)
    order = Order.find(order_id)
    zip_code = 25204
    iva = 0.16
    base_earning = 10.0
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
               "valor_unitario": subtotal,
               "descripcion": "Servicios profesionales para la orden #{order.uuid}",
               "importe": subtotal,
               "clave": "80141600",
               "clave_unidad": "E48",
               "traslados": [
                   {
                       "impuesto": "002",
                       "base": subtotal,
                       "tipo_factor": "Tasa",
                       "tasa": iva,
                       "importe": order_tax(subtotal)
                   }
               ]
              },
              {"identificador": "Base #{order.uuid}",
               "cantidad": 1,
               "unidad": "Base",
               "valor_unitario": base_earning,
               "descripcion": "Base para la orden #{order.uuid}",
               "importe": base_earning,
               "clave": "80141600",
               "clave_unidad": "E48",
               "traslados": [
                   {
                       "impuesto": "002",
                       "base": base_earning,
                       "tipo_factor": "Tasa",
                       "tasa": iva,
                       "importe": (base_earning * iva).round(2)
                   }
               ]
              }]
      impuestos_traslado =  [{"impuesto": "002",
                              "tasa": iva,
                              "importe": concept[0][:traslados][0][:importe],
                              "tipo_factor": "Tasa"
                            },
                            {"impuesto": "002",
                             "tasa": iva,
                             "importe": concept[1][:traslados][0][:importe],
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
                 "total_trasladados": (concept[0][:traslados][0][:importe] + concept[1][:traslados][0][:importe]).round(2)
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
