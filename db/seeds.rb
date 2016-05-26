# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# ! raises an exception if it causes an error
User.create!(name:                  "Example User", 
             email:                 "example@rails.com", 
             password:              "dudeyeah", 
             password_confirmation: "dudeyeah", 
             admin:                 true,
             activated:             true,
             activated_at:          Time.zone.now)

99.times { |n|
  name     = Faker::Name.name
  email    = "example-#{n+1}@railstutorial.org"
  password = "password"
  admin    = false
  User.create!(name:                  name, 
               email:                 email, 
               password:              password, 
               password_confirmation: password, 
               admin:                 admin,
               activated:             true,
               activated_at:          Time.zone.now)
}

users = User.order(:created_at).take(6) #.first(6)
50.times {
  content = Faker::Lorem.sentence(5)
  users.each {|user|
    user.microposts.create!(content: content)
  }
}