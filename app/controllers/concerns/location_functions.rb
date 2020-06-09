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

end
