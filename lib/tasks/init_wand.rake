task :init_wand => [:environment] do
  User.all.each do |user|
    if user.phone_number.present? && !user.phone_number.include?("+52")
      user.update(phone_number: "+52 " + user.phone_number[0..2]+" "+user.phone_number[3..5]+ " "+ user.phone_number[6..-1])
    end
  end
  puts "Teléfonos actualizados a +52"
  ##############################
  Gig.all.each do |gig|
    gig.update_columns(lowest_price: gig.gig_packages.first.lowest_price) if gig.gig_packages.any? && gig.gig_packages.first.price.present?
  end
  puts "Los precios de los primeros paquetes han sido agregados en una golumna de gig..."
  #######################
  Gig.all.each do |gig|
    gig.lat = 19.4326077
    gig.lng = -99.133208
    gig.address_name = "Ciudad de México, México"
    if gig.city_id.present?
      begin
      obj=Geokit::Geocoders::GoogleGeocoder.geocode "#{gig.city.name}, #{gig.city.state.name}, #{gig.city.state.country.name}"
      gig.lat = obj.lat
      gig.lng = obj.lng
      gig.address_name = obj.formatted_address
      rescue
        #nothing
      end
    end
    gig.save
  end
  puts "Todos los jales han actualizado su ubicacion a coordenadas, ahora corriendo los pedidos..."
  ##############################################################
  Request.all.each do |req|
    req.lat = 19.4326077
    req.lng = -99.133208
    req.address_name = "Ciudad de México, México"
    if req.city_id.present?
      begin
      obj=Geokit::Geocoders::GoogleGeocoder.geocode "#{req.city.name}, #{req.city.state.name}, #{req.city.state.country.name}"
      req.lat = obj.lat
      req.lng = obj.lng
      req.address_name = obj.formatted_address
      rescue
        #nothing
      end
    end
    req.save
  end
  puts "Todos los pedidos han actualizado su ubicacion a coordenadas, ahora corriendo los usuarios..."
  ###############################################################
  User.all.each do |user|
    user.lat = 19.4326077
    user.lng = -99.133208
    user.address_name = "Ciudad de México, México"
    if user.city_id.present?
      begin
      obj=Geokit::Geocoders::GoogleGeocoder.geocode "#{user.city.name}, #{user.city.state.name}, #{user.city.state.country.name}"
      user.lat = obj.lat
      user.lng = obj.lng
      user.address_name = obj.formatted_address
      rescue
        #nothing
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
