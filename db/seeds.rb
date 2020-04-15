#create all the professions and categories
require "#{Rails.root}/db/init_seeds/categories"
require "#{Rails.root}/db/init_seeds/professions"

include RequestsHelper

  100.times do |x|
    User.create! do |user|
      loc = Geokit::Geocoders::GoogleGeocoder.reverse_geocode("#{rand(21.8..22.0)},#{rand(-102.4..-102.3)}")
      user.name = Faker::Name.first_name
      user.email = Faker::Internet.email + "#{x}"
      user.role = "user"
      user.password = "1234aA"
      user.current_sign_in_at = Time.now()
      user.lat = loc.lat || 21.8852562
      user.lng = loc.lng || -102.2915677
      user.address_name = (loc.full_address.present?)? loc.full_address : "Aguascalientes, Ags., México"
      user.birth = rand(50.years).seconds.ago
      user.website = Faker::Internet.url
      user.facebook = Faker::Internet.url("facebook.com")
      user.instagram = Faker::Internet.url("instagram.com")

      # This is so we dont have to confirm the email on seeds
      user.confirmed_at = Time.now
      1.times do |y|
        user.requests.new do |request|
          request.name = Faker::Company.industry + "#{x}#{y}"
          request.description = Faker::Lorem.paragraph(30, true)
          request.lat = loc.lat || 21.8852562
          request.lng = loc.lng || -102.2915677
          request.address_name = (loc.full_address.present?)? loc.full_address : "Aguascalientes, Ags., México"
          request.category_id = Faker::Number.between(1, 10)
          request.budget = options_for_budget[Faker::Number.between(0, (options_for_budget.count - 1))]
          request.status = Faker::Number.between(0, 5)
          request.profession = Profession.find( Faker::Number.between(1, 20) ).name
        end
      end
      1.times do
        user.gigs.new do |gig|
          gig.name = "#{Faker::Lorem.paragraph(2, true)}"
          gig.description = Faker::Lorem.paragraph(30, true)
          gig.lat = loc.lat || 21.8852562
          gig.lng = loc.lng || -102.2915677
          gig.address_name = (loc.full_address.present?)? loc.full_address : "Aguascalientes, Ags., México"
          gig.category_id = Faker::Number.between(1, 5)
          gig.status = Faker::Number.between(0, 2)
          gig.profession = Profession.find( Faker::Number.between(1, 20) ).name
        end
      end
      puts user.email
    end
  end

  100.times do |x|
    3.times do |y|
      @pack = Package.create! do |package|
        package.name = Faker::Commerce.product_name + "#{x}#{y}"
        package.description = Faker::Lorem.paragraph(30, true)
        package.price = Faker::Number.between(200, 500)
        package.gig_id = x+1
        package.pack_type = y
      end
      @pack.gig.update(lowest_price: @pack.price) if @pack.pack_type == "basic"
    end
  end

  puts "Created gigs and packages"

  User.create!(
        email: "admin@e.com",
        password: "Admin1",
        name: "admin",
        role: "admin",
        confirmed_at: Time.now
   )
  puts "Created an admin"

  User.create!(
        email: "testuser1@jalecitos.com",
        password: "Test12",
        name: "Test User",
        role: "user",
        confirmed_at: Time.now
   )
  puts "Created testing user1"

  User.create!(
        email: "testuser2@jalecitos.com",
        password: "Test12",
        name: "Test User",
        role: "user",
        confirmed_at: Time.now
   )
  puts "Created testing user2"

# reindex has been moved to rake task, check jalecitos-cli
