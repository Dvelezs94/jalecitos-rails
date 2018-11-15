# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
20.times do |x|
    Category.create! do |category|
      category.name = Faker::Company.industry + "#{x}"
    end
end

20.times do |x|
  User.create! do |user|
    user.name = Faker::Name.name + "#{x}"
    user.email = Faker::Internet.email + "#{x}"
    user.role = "user"
    user.password = "123456"
    # This is so we dont have to confirm the email on seeds
    user.confirmed_at = Time.now
    10.times do |y|
      user.requests.new do |request|
        request.name = Faker::Company.industry + "#{x}#{y}"
        request.description = Faker::Lorem.paragraph(30, true)
        request.location = "#{Faker::Address.state}, México"
        request.category_id = Faker::Number.between(1, 10)
        request.budget = Faker::Number.between(100, 5000)
      end
    end
    10.times do |x|
      user.gigs.new do |gig|
        gig.name = "#{Faker::Lorem.paragraph(2, true)}"
        gig.description = Faker::Lorem.paragraph(30, true)
        gig.location = "#{Faker::Address.state}, México"
        gig.category_id = Faker::Number.between(1, 5)
        gig.status = Faker::Number.between(0, 2)
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
      role: "admin"
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

reindex_list = [Gig, Request]
reindex_list.each do |model|
  model.reindex
end
puts "reindex has finished"
