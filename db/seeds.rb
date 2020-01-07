#create all the professions and categories
require "#{Rails.root}/db/init_seeds/categories"
require "#{Rails.root}/db/init_seeds/professions"
require "#{Rails.root}/db/init_seeds/mx_places"
include RequestsHelper

# Populate DB with Mexico places
Country.create(name: "MX")

if ENV.fetch("RAILS_ENV") == "production"
  InitMexicoPlaces.all.keys.each do |state|
    State.create(name: state, country_id: 1)
  end
  InitMexicoPlaces.all.values.each_with_index do |cities, n|
    cities.each do |city|
      City.create(name: city, state_id: n+1)
    end
  end
end


#fill db with fake info for development
if ENV.fetch("RAILS_ENV") != "production"
  InitMexicoPlaces.all.keys.each do |state|
    State.create(name: state, country_id: 1)
  end
  InitMexicoPlaces.all.values.each_with_index do |cities, n|
    cities.in_groups_of(5).first.each do |city|
      City.create(name: city, state_id: n+1)
    end
  end
  20.times do |x|
    User.create! do |user|
      user.name = Faker::Name.first_name
      user.email = Faker::Internet.email + "#{x}"
      user.role = "user"
      user.password = "1234aA"
      user.current_sign_in_at = Time.now()
      user.city_id = Faker::Number.between(1, 5)
      user.age = Faker::Number.between(18, 50)
      # This is so we dont have to confirm the email on seeds
      user.confirmed_at = Time.now
      20.times do |y|
        user.requests.new do |request|
          request.name = Faker::Company.industry + "#{x}#{y}"
          request.description = Faker::Lorem.paragraph(30, true)
          request.city_id = Faker::Number.between(1, 5)
          request.category_id = Faker::Number.between(1, 10)
          request.budget = options_for_budget[Faker::Number.between(0, (options_for_budget.count - 1))]
          request.status = Faker::Number.between(0, 5)
          request.profession = Profession.find( Faker::Number.between(1, 20) ).name
        end
      end
      10.times do
        user.gigs.new do |gig|
          gig.name = "#{Faker::Lorem.paragraph(2, true)}"
          gig.description = Faker::Lorem.paragraph(30, true)
          gig.city_id = Faker::Number.between(1, 5)
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
end

# reindex has been moved to rake task, check jalecitos-cli
