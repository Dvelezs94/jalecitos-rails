# require 'openpay'
#
# module OpenPay
#   class Init
#     merchant_id = ENV.fetch('OPENPAY_MERCHANT_ID')
#     private_key = ENV.fetch('OPENPAY_PRIVATE_KEY')
#     production = ENV.fetch('OPENPAY_PROD')
#     # we do this because of how docker send the var as string and not boolean
#     Openpay=OpenpayApi.new(merchant_id, private_key, production == "true" ? true : false)
#   end
# end
