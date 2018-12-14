module AliasFunctions
  private
  def set_alias
    if self.alias.nil?
      login_part = self.email.split("@").first
      hex = SecureRandom.hex(3)
      self.alias = "#{ login_part }-#{ hex }"
    end
  end
end
