# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  "Example Admin",
             email: "example_admin@email.com",
             password:              "123456",
             password_confirmation: "123456",
             role: "Admin")
             
User.create!(name:  "Example SuperAdmin",
             email: "example_superadmin@email.com",
             password:              "123456",
             password_confirmation: "123456",
             role: "SuperAdmin")
             
User.create!(name:  "Example Customer",
             email: "example_customer@email.com",
             password:              "123456",
             password_confirmation: "123456",
             role: "Customer")

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  role = "Customer"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password, 
               role: role)
end