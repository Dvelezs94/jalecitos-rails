module OpenpayFunctions
  def balance
    @balance = 0.0
    @order_ids = []
    @refunded = self.purchases.refunded.where(paid_at: nil)
    @sales = self.sales.completed.where(paid_at: nil)
    @join = @sales + @refunded
    @join.each do |b|
      @balance += b.total
      @order_ids << b.id
    end
    return {amount: @balance, order_ids: @order_ids}
  end
  private
  #  Deactivate user only instead of deleting
  def destroy
    @user_gigs = Gig.where(user_id: self.id)
    @user_gigs.each do |gig|
      (gig.published?)? gig.draft! : nil
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
        "name" => self.alias,
        "last_name" => nil,
        "email" => self.email,
        "requires_account" => false
      }

      begin
        response_hash = @customer.create(request_hash.to_hash)
        self.openpay_id = response_hash['id']
        save
      rescue OpenpayTransactionException => e
         puts "#{self.alias} issue: #{e.description}, so the user could not be created on openpay"
      end
    end
  end
end
