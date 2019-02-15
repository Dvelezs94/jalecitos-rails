module LocationFunctions
  require "i18n"
  def get_location lat, lon
    begin
      loc = Geokit::Geocoders::GoogleGeocoder.reverse_geocode "#{lat},#{lon}"
      (loc.country == "Mexico")? I18n.transliterate( [loc.city, loc.state_name, loc.country_code].join(", ") ) : nil
    rescue Geokit::Geocoders::GeocodeError
      nil
    end
  end
end
