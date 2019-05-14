module AliasFunctions
  private
  def set_alias
    if self.alias.nil?
      begin
        login_part = self.email.split("@").first.gsub(/[^a-zA-Z0-9\-\_]/,"")
        hex = SecureRandom.hex(5)
        self.alias = "#{ login_part.first(19)}-#{ hex }" #alias is maximum 30 chars, 19 from mail (max), the "-", and 10 from hex
      rescue
        self.alias = "Usuario-#{SecureRandom.hex(11)}" #esto nunca se va a usar de seguro porque si entra el mail es porque es bueno, entonces se generara bien todo el alias
      end
    end
  end

  def test_mail mail
    mail.split("@").first.gsub(/[^a-zA-Z0-9\-\_]/,"")
  end
end
