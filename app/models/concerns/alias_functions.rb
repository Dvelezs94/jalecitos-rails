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
    begin
      loc = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{lat},#{lon}"
      geoloc = [loc.city, loc.state, loc.country].join(", ")
      self.location = geoloc if (loc.country == "Mexico")
    rescue Geokit::Geocoders::GeocodeError
      true
    end
  end
end
