module LocationFunctions
  def location(empty_if_nil=false)
    if address_name
      "#{address_name}"
    elsif empty_if_nil == false
      "Cualquier lugar"
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

end
