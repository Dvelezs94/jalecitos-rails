task :init_wand2 => [:environment] do
  time = Time.parse("2020-07-01 16:44:52.053554")+20.minute
  #######################
  Gig.where("updated_at > ?", time).each do |gig|
    if gig.city_id.nil?
      gig.lat = 19.4326077
      gig.lng = -99.133208
      gig.address_name = "Ciudad de México, México"
    elsif gig.city.name.include?("Ciudad De M")
      gig.lat = 19.4326077
      gig.lng = -99.133208
      gig.address_name = "Ciudad de México, México"
    elsif gig.city.name.include?("Saltillo")
      gig.lat = 25.4383234
      gig.lng = -100.973678
      gig.address_name = "Saltillo, Coah., México"
    elsif gig.city.name.include?("Monterr")
      gig.lat = 25.6866142
      gig.lng = -100.3161126
      gig.address_name = "Monterrey, N.L., México"
    else
      begin
      obj=Geokit::Geocoders::GoogleGeocoder.geocode "#{gig.city.name}, #{gig.city.state.name}, #{gig.city.state.country.name}"
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
  Request.where("updated_at > ?", time).each do |req|
    if req.city_id.nil?
      req.lat = 19.4326077
      req.lng = -99.133208
      req.address_name = "Ciudad de México, México"
    elsif req.city.name.include?("Ciudad De M")
      req.lat = 19.4326077
      req.lng = -99.133208
      req.address_name = "Ciudad de México, México"
    elsif req.city.name.include?("Saltillo")
      req.lat = 25.4383234
      req.lng = -100.973678
      req.address_name = "Saltillo, Coah., México"
    elsif req.city.name.include?("Monterr")
      req.lat = 25.6866142
      req.lng = -100.3161126
      req.address_name = "Monterrey, N.L., México"
    else
      begin
      obj=Geokit::Geocoders::GoogleGeocoder.geocode "#{req.city.name}, #{req.city.state.name}, #{req.city.state.country.name}"
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
  User.where("updated_at > ?", time).each do |user|
    if user.city_id.nil?
      user.lat = 19.4326077
      user.lng = -99.133208
      user.address_name = "Ciudad de México, México"
    elsif user.city.name.include?("Ciudad De M")
      user.lat = 19.4326077
      user.lng = -99.133208
      user.address_name = "Ciudad de México, México"
    elsif user.city.name.include?("Saltillo")
      user.lat = 25.4383234
      user.lng = -100.973678
      user.address_name = "Saltillo, Coah., México"
    elsif user.city.name.include?("Monterr")
      user.lat = 25.6866142
      user.lng = -100.3161126
      user.address_name = "Monterrey, N.L., México"
    else
      begin
      obj=Geokit::Geocoders::GoogleGeocoder.geocode "#{user.city.name}, #{user.city.state.name}, #{user.city.state.country.name}"
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
  # ActiveRecord::Migration.remove_column :gigs, :order_count
  # ActiveRecord::Migration.remove_column :gigs, :city_id
  # ActiveRecord::Migration.remove_column :requests, :city_id
  # ActiveRecord::Migration.remove_column :users, :city_id
  # ActiveRecord::Migration.remove_column :users, :openpay_id
  # ActiveRecord::Migration.remove_column :users, :secure_transaction
  # ActiveRecord::Migration.remove_column :users, :secure_transaction_job_id
  # puts "Se ha eliminado la columna city_id de gigs,req y users y order_count de gig, ya que no guardamos ciudades y no se contrata por app, además se eliminaron los campos de openpayu en users"
  # puts "Borrando tablas de ciudad, estado y país"
  # ActiveRecord::Base.connection.execute("drop table countries CASCADE")
  # ActiveRecord::Base.connection.execute("drop table states CASCADE")
  # ActiveRecord::Base.connection.execute("drop table cities CASCADE")
  # puts "Se han borrado las tablas"
  # City.search_index.delete
  #
  # puts "Se borró el search index de cities en elasticsearch"

  #####################################
  reindex_list = [Gig, Request, User]
  reindex_list.each do |model|
    model.reindex
  end


  puts "Se hizo el reindex de gigs, requests y users"

  puts "Task finalizado con éxito."
end
