module OpenpayHelper

  def init_openpay resource
    @openpay ||= OpenPay::Init::Openpay

    case
      when resource == "bank"
        @bank_account = @openpay.create(:bankaccounts)
      when resource == "card"
        @card = @openpay.create(:cards)
      when resource == "customer"
        @customer = @openpay.create(:customers)
      end
    end

    def get_openpay_resource resource, openpay_id
      init_openpay(resource).all(openpay_id)
    end
end
