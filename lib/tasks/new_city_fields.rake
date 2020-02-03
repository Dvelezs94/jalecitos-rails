task :new_city_fields => [:environment] do
  Gig.first(2).each do |gig|
    obj=Geokit::Geocoders::GoogleGeocoder.geocode gig.location
    gig.lat = obj.lat
    gig.lng = obj.lng
    gig.address_name = obj.formatted_address
    gig.save
  end
  #ActiveRecord::Migration.remove_column :gigs, :city_id
  puts "Todos los jales han actualizado su ubicacion a coordenadas, ahora corriendo los pedidos"
  ##############################################################
  Request.first(2).each do |req|
    obj=Geokit::Geocoders::GoogleGeocoder.geocode req.location
    req.lat = obj.lat
    req.lng = obj.lng
    req.address_name = obj.formatted_address
    req.save
  end
  #ActiveRecord::Migration.remove_column :requests, :city_id
  puts "Todos los pedidos han actualizado su ubicacion a coordenadas, ahora corriendo los usuarios"
  ###############################################################
  User.first(2).each do |user|
    obj=Geokit::Geocoders::GoogleGeocoder.geocode user.location
    user.lat = obj.lat
    user.lng = obj.lng
    user.address_name = obj.formatted_address
    user.save
  end
  #ActiveRecord::Migration.remove_column :requests, :city_id
  puts "Todos los usuarios han actualizado su ubicacion a coordenadas, borrando tablas de ciudades, estados y países"
  # ActiveRecord::Migration.drop_table :cities
  # ActiveRecord::Migration.drop_table :states
  # ActiveRecord::Migration.drop_table :countries
  puts "Se han borrado las tablas, finalizado todo con éxito"
end
