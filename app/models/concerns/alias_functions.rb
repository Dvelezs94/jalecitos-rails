module AliasFunctions
  private
  def set_alias
    if self.alias.nil?
      begin
        login_part = self.email.split("@").first.gsub(/[^a-zA-Z0-9\-\_]/,"")
        hex = SecureRandom.hex(3)
        self.alias = "#{ login_part }-#{ hex }"
      rescue
        self.alias = SecureRandom.hex(4)
      end
    end
  end

  def test_mail mail
    mail.split("@").first.gsub(/[^a-zA-Z0-9\-\_]/,"")
  end
end
