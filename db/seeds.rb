# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
20.times do |x|
    Category.create do |category|
      category.name = Faker::Company.industry
    end
end

20.times do
  User.create do |user|
    user.email = Faker::Internet.email
    user.role = "user"
    user.password = "123456"
    10.times do
      user.gigs.new do |gig|
        gig.name = Faker::Hacker.say_something_smart
        gig.description = Faker::Lorem.paragraphs
        gig.location = Faker::Address.state
        gig.category_id = Faker::Number.between(0, 19)
        gig.status = Faker::Number.between(0, 2)
      end
    end
    10.times do
      user.requests.new do |request|
        request.name = Faker::Hacker.say_something_smart
        request.description = Faker::Lorem.paragraph(30, true)
        request.location = Faker::Address.state
        request.category_id = 1
        request.budget = Faker::Number.between(100, 5000)
      end
    end
  end
end


puts "Created gigs"

User.create!(
      email: "admin@e.com",
      password: "adminpassword",
      role: "admin"
 )
puts "Created an admin"
