module LocationFunctions
  def location(empty_if_nil=false)
    if city && empty_if_nil == false
      "#{city.name}, #{city.state.name}, #{city.state.country.name}"
    elsif city && empty_if_nil == true
      true
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
  def get_city_id_in_db(city, state, country)
    @country = Country.find_by_name(country)
    @state = State.find_by(name: state, country: @country)
    @city = City.find_by(name: city, state: @state)
    if @city
      return @city.id
    else
      return nil
    end
  end

end
