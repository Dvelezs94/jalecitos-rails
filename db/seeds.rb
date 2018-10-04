# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
5.times do |x|
   User.create!(
         email: "#{x}@example.com",
         password: "password#{x}",
    )
end
puts "Created 5 users"

5.times do |x|
    Category.create!(
          name: "Category #{x}",
     )
end
puts "Created 5 categories"

User.create!(
      email: "admin@example.com",
      password: "adminpassword",
      role: "admin"
 )
