module ConektaFunctions
  private

  def create_conekta_account
    begin
      # Create the conekta customwer if it doesnt exist
      if self.conekta_id.nil?
        # Create default hash for new user
        request_hash={
          :name => self.alias,
          :email => self.email
        }
        response_hash = Conekta::Customer.create(request_hash)
        self.conekta_id = response_hash["id"]
        save
      end
    rescue => e
      #do nothing if something fails with conekta
    end
  end
  
end
