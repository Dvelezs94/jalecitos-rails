#create all the professions and categories
require "#{Rails.root}/db/init_seeds/categories"
require "#{Rails.root}/db/init_seeds/professions"
require "#{Rails.root}/db/init_seeds/mx_places"

# Populate DB with Mexico places
InitMexicoPlaces.all.keys.each do |state|
  State.create(name: state)
end
InitMexicoPlaces.all.values.each_with_index do |cities, n|
  cities.each do |city|
    City.create(name: city, state_id: n+1)
  end
end


#fill db with fake info for development
if ENV.fetch("RAILS_ENV") == "development"
  20.times do |x|
    User.create! do |user|
      user.name = Faker::Name.name + "#{x}"
      user.email = Faker::Internet.email + "#{x}"
      user.role = "user"
      user.password = "123456"
      user.current_sign_in_at = Time.now()
      # This is so we dont have to confirm the email on seeds
      user.confirmed_at = Time.now
      20.times do |y|
        user.requests.new do |request|
          request.name = Faker::Company.industry + "#{x}#{y}"
          request.description = Faker::Lorem.paragraph(30, true)
          request.location = "#{Faker::Address.state}, México"
          request.category_id = Faker::Number.between(1, 10)
          request.budget = Faker::Number.between(100, 5000)
          request.status = Faker::Number.between(0, 4)
          request.profession = Profession.find( Faker::Number.between(1, 20) ).name
        end
      end
      10.times do
        user.gigs.new do |gig|
          gig.name = "#{Faker::Lorem.paragraph(2, true)}"
          gig.description = Faker::Lorem.paragraph(30, true)
          gig.location = "#{Faker::Address.state}, México"
          gig.category_id = Faker::Number.between(1, 5)
          gig.status = Faker::Number.between(0, 2)
          gig.profession = Profession.find( Faker::Number.between(1, 20) ).name
        end
      end
      puts user.email
    end
  end

  200.times do |x|
    3.times do |y|
      Package.create! do |package|
        package.name = Faker::Commerce.product_name + "#{x}#{y}"
        package.description = Faker::Lorem.paragraph(30, true)
        package.price = Faker::Number.between(200, 500)
        package.gig_id = x+1
        package.pack_type = y
      end
    end
  end

  puts "Created gigs and packages"

  User.create!(
        email: "admin@e.com",
        password: "adminpassword",
        name: "admin",
        role: "admin",
        confirmed_at: Time.now
   )
  puts "Created an admin"

  User.create!(
        email: "testuser1@jalecitos.com",
        password: "testuserpass",
        name: "Test User",
        role: "user",
        confirmed_at: Time.now
   )
  puts "Created testing user1"

  User.create!(
        email: "testuser2@jalecitos.com",
        password: "testuserpass",
        name: "Test User",
        role: "user",
        confirmed_at: Time.now
   )
  puts "Created testing user2"
end

# reindex has been moved to rake task, check jalecitos-cli
