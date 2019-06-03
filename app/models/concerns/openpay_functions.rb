module OpenpayFunctions

  private
  #  Deactivate user only instead of deleting
  def destroy
    @user_gigs = Gig.where(user_id: self.id)
    @user_gigs.each do |gig|
      gig.draft! if gig.published?
    end
    @user_requests = Request.where(user_id: self.id)
    @user_requests.each do |request|
      request.closed!
    end
    disabled!
    update_attributes(openpay_id: "0")
  end


  def create_openpay_account
    # Create openpay Account if not already there
    if self.openpay_id.nil?
      init_openpay("customer")

      # Create default hash for new user
      request_hash={
        "name" => (self.name || self.alias),
        "last_name" => nil,
        "email" => self.email,
        "requires_account" => true
      }

      begin
        response_hash = @customer.create(request_hash.to_hash)
        self.openpay_id = response_hash['id']
      rescue
         true
      end
    end
  end

  def pay_to_customer(order, transfer)
    request_hash = {
      "customer_id" => ENV.fetch("OPENPAY_PREDISPERSION_CLIENT"),
      "amount" => order.purchase.price,
      "description" => "Pago de orden #{order.uuid} por la cantidad de #{order.purchase.price}",
      "order_id" => "#{order.uuid}-complete"
    }
    begin
      response = transfer.create(request_hash, order.employer.openpay_id)
      order.update(response_completion_id: response["id"])
    rescue
      order.update(response_completion_id: "failed")
    end
  end

  def create_order order, request_hash, min_3d_amount
    response = @charge.create(request_hash, current_user.openpay_id)
    order.update(response_order_id: response["id"])
    flash[:success] = "Se ha creado la orden."
    redirect_to (order.total > min_3d_amount) ? response["payment_method"]["url"] : finance_path(:table => "purchases")
  end

  def create_order_failed order, e
    order.update(response_order_id: "failed")
    order.denied!
    flash[:error] = "#{e.description}, por favor, inténtalo de nuevo."
    redirect_to finance_path(:table => "purchases")
  end

  def try_to_refund order
    request_hash = {
      "description" => "Monto de la orden #{order.uuid} devuelto por la cantidad de #{order.total}",
      "amount" => order.total
    }
    response = @charge.refund(order.response_order_id ,request_hash, order.employer.openpay_id)
    order.update(response_refund_id: response["id"], status: "refund_in_progress")
  end

  def charge_fee(order, fee)
    request_fee_hash={"customer_id" => order.employer.openpay_id,
                   "amount" => get_order_earning(order.purchase.price),
                   "description" => "Cobro de Comisión por la orden #{order.uuid}",
                   "order_id" => "#{order.uuid}-fee"
                  }
    begin
      response_fee = fee.create(request_fee_hash)
      order.update(response_fee_id: response_fee["id"])
    rescue
      order.update(response_fee_id: "failed")
    end
  end

  def charge_tax(order, fee)
    request_tax_hash={"customer_id" => order.employer.openpay_id,
                   "amount" => order_tax(order.purchase.price),
                   "description" => "Cobro de impuesto por la orden #{order.uuid}",
                   "order_id" => "#{order.uuid}-tax"
                  }
    begin
      response_tax = fee.create(request_tax_hash)
      order.update(response_tax_id: response_tax["id"])
    rescue
      order.update(response_tax_id: "failed")
    end
  end

  def openpay_tax(order, fee)
    request_tax_hash={"customer_id" => order.employer.openpay_id,
                   "amount" => calc_openpay_tax(order.total),
                   "description" => "Cobro de impuesto para openpay por la orden #{order.uuid}",
                   "order_id" => "#{order.uuid}-openpay-tax"
                  }
    begin
      response_tax = fee.create(request_tax_hash)
      order.update(response_openpay_tax_id: response_tax["id"])
    rescue
      order.update(response_openpay_tax_id: "failed")
    end
  end


end
