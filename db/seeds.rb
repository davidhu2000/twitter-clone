# Users
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

# Microposts
users = User.order(:created_at).take(6) #.first(6)
50.times {
  content = Faker::Lorem.sentence(5)
  users.each {|user|
    user.microposts.create!(content: content)
  }
}

#Following relationships
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }