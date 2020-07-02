task :init_wand2 => [:environment] do
  time = Time.parse("2020-07-01 16:44:52.053554")+20.minute
  #######################
  Gig.where("updated_at < ?", time).each do |gig|
    city = City.find(gig.city_id) if gig.city_id.present?
    if gig.city_id.nil? || city.name.include?("Ciudad De M")
      gig.lat = 19.4326077
      gig.lng = -99.133208
      gig.address_name = "Ciudad de México, México"
    elsif city.name.include?("Saltillo")
      gig.lat = 25.4383234
      gig.lng = -100.973678
      gig.address_name = "Saltillo, Coah., México"
    elsif city.name.include?("Monterr")
      gig.lat = 25.6866142
      gig.lng = -100.3161126
      gig.address_name = "Monterrey, N.L., México"
    else
      begin
      obj=Geokit::Geocoders::GoogleGeocoder.geocode "#{city.name}, #{city.state.name}, #{city.state.country.name}"
      gig.lat = obj.lat
      gig.lng = obj.lng
      gig.address_name = obj.formatted_address
      rescue
        gig.lat = 19.4326077
        gig.lng = -99.133208
        gig.address_name = "Ciudad de México, México"
      end
    end
    gig.save
  end
  puts "Todos los jales han actualizado su ubicacion a coordenadas, ahora corriendo los pedidos..."
  ##############################################################
  Request.where("updated_at < ?", time).each do |req|
    city = City.find(req.city_id) if req.city_id.present?
    if req.city_id.nil? || city.name.include?("Ciudad De M")
      req.lat = 19.4326077
      req.lng = -99.133208
      req.address_name = "Ciudad de México, México"
    elsif city.name.include?("Saltillo")
      req.lat = 25.4383234
      req.lng = -100.973678
      req.address_name = "Saltillo, Coah., México"
    elsif city.name.include?("Monterr")
      req.lat = 25.6866142
      req.lng = -100.3161126
      req.address_name = "Monterrey, N.L., México"
    else
      begin
      obj=Geokit::Geocoders::GoogleGeocoder.geocode "#{city.name}, #{city.state.name}, #{city.state.country.name}"
      req.lat = obj.lat
      req.lng = obj.lng
      req.address_name = obj.formatted_address
      rescue
        req.lat = 19.4326077
        req.lng = -99.133208
        req.address_name = "Ciudad de México, México"
      end
    end
    req.save
  end
  puts "Todos los pedidos han actualizado su ubicacion a coordenadas, ahora corriendo los usuarios..."
  ###############################################################
  User.where("updated_at < ?", time).each do |user|
    city = City.find(user.city_id) if user.city_id.present?
    if user.city_id.nil? || city.name.include?("Ciudad De M")
      user.lat = 19.4326077
      user.lng = -99.133208
      user.address_name = "Ciudad de México, México"
    elsif city.name.include?("Saltillo")
      user.lat = 25.4383234
      user.lng = -100.973678
      user.address_name = "Saltillo, Coah., México"
    elsif city.name.include?("Monterr")
      user.lat = 25.6866142
      user.lng = -100.3161126
      user.address_name = "Monterrey, N.L., México"
    else
      begin
      obj=Geokit::Geocoders::GoogleGeocoder.geocode "#{city.name}, #{city.state.name}, #{city.state.country.name}"
      user.lat = obj.lat
      user.lng = obj.lng
      user.address_name = obj.formatted_address
      rescue
        user.lat = 19.4326077
        user.lng = -99.133208
        user.address_name = "Ciudad de México, México"
      end
    end
    user.save
  end
  puts "Todos los usuarios han actualizado su ubicacion a coordenadas, reindexando..."
  ##################
  reindex_list = [Gig, Request, User]
  reindex_list.each do |model|
    model.reindex
  end


  puts "Se hizo el reindex de gigs, requests y users"

  puts "Task finalizado con éxito."
end
