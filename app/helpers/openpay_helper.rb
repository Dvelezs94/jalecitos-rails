module OpenpayHelper

  # initiate openpay, just specify the resource and it will return the object initialized
  def init_openpay resource
    @openpay ||= OpenPay::Init::Openpay

    case
      when resource == "bank"
        @bank_account = @openpay.create(:bankaccounts)
      when resource == "card"
        @card = @openpay.create(:cards)
      when resource == "customer"
        @customer = @openpay.create(:customers)
      when resource == "charge"
        @charge = @openpay.create(:charges)
      end
    end

    #  Get all items from that openpay resource
    def get_openpay_resource resource, openpay_id
      init_openpay(resource).all(openpay_id)
    end
end
