module LocationFunctions
  def location(empty_if_nil=false)
    if city
      "#{city.name}, #{city.state.name}, #{city.state.country.name}"
    elsif empty_if_nil == false
      "Ciudad Indefinida"
    else
      nil
    end
  end
  private
  #used in gigs and requests
  def location_validate
    if city == ""
      errors.add(:base, "La ubicación debe ser una proporcionada en las opciones.")
    end
  end

  # used in users
  def geoloc_to_city(city, state, country)
    @country = Country.find_by_name(country)
    @state = State.where(name: state, country: country)
    @city = City.where(name: city, state: state)
    if @city
      return @city.id
    else
      return nil
    end
  end

end
