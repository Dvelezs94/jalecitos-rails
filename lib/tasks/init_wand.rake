task :init_wand => [:environment] do
  User.all.each do |user|
    if user.phone_number.present?
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
  Gig.last(2).each do |gig|
    obj=Geokit::Geocoders::GoogleGeocoder.geocode gig.location
    gig.lat = obj.lat
    gig.lng = obj.lng
    gig.address_name = obj.formatted_address
    gig.save
  end
  puts "Todos los jales han actualizado su ubicacion a coordenadas, ahora corriendo los pedidos..."
  ##############################################################
  Request.last(2).each do |req|
    obj=Geokit::Geocoders::GoogleGeocoder.geocode req.location
    req.lat = obj.lat
    req.lng = obj.lng
    req.address_name = obj.formatted_address
    req.save
  end
  puts "Todos los pedidos han actualizado su ubicacion a coordenadas, ahora corriendo los usuarios..."
  ###############################################################
  User.last(2).each do |user|
    obj=Geokit::Geocoders::GoogleGeocoder.geocode user.location
    user.lat = obj.lat
    user.lng = obj.lng
    user.address_name = obj.formatted_address
    user.save
  end
  puts "Todos los usuarios han actualizado su ubicacion a coordenadas, borrando columnas innecesarias..."
  ##################
  ActiveRecord::Migration.remove_column :gigs, :order_count
  ActiveRecord::Migration.remove_column :gigs, :city_id
  ActiveRecord::Migration.remove_column :requests, :city_id
  ActiveRecord::Migration.remove_column :users, :city_id
  ActiveRecord::Migration.remove_column :users, :openpay_id
  ActiveRecord::Migration.remove_column :users, :secure_transaction
  ActiveRecord::Migration.remove_column :users, :secure_transaction_job_id
  puts "Se ha eliminado la columna city_id de gigs,req y users y order_count de gig, ya que no guardamos ciudades y no se contrata por app, además se eliminaron los campos de openpayu en users"
  puts "Borrando tablas de ciudad, estado y país"
  ActiveRecord::Base.connection.execute("drop table countries CASCADE")
  ActiveRecord::Base.connection.execute("drop table states CASCADE")
  ActiveRecord::Base.connection.execute("drop table cities CASCADE")
  puts "Se han borrado las tablas, reindexando..."

  #####################################
  reindex_list = [Gig, Request, User]
  reindex_list.each do |model|
    model.reindex
  end


  puts "Se hizo el reindex de gigs, requests y users"
  City.search_index.delete

  puts "Se borró el search index de cities en elasticsearch"

  puts "Task finalizado con éxito."
end
