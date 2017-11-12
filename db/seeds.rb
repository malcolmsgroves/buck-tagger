# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

(1..50).each do |x|
  user = User.create!(name: Faker::Name.name,
                      birthdate: Faker::Date.between(50.years.ago, 10.years.ago),
                      password: "foobar",
                      password_confirmation: "foobar",
                      email: "example#{x}@hunters.com")
end

# Following relationships
users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
