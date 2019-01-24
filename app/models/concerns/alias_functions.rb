module AliasFunctions
  private
  def set_alias
    if self.alias.nil?
      login_part = self.email.split("@").first
      hex = SecureRandom.hex(3)
      self.alias = "#{ login_part }-#{ hex }"
    end
  end

  def set_location
    location = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{request.location.latitude},#{request.location.longitude}"
    self.location = [location.city, location.state, location.country].join(", ") if location.present?
  end
end
