# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# User.create(email: "sonamax809@gmail.com", username: "Sonam", password: "sonam123", role: true)
# User.create(username: "Chophel", password: "chophel123", role: true)
# User.create(email: "birendrabhujel3@gmail.com", username: "Birendra", password: "birendra123", role: false)


List.create( title: 'Go to Gym', description: "Go to gym at Thimphu 10 am", isComplete: false, user_id: 4)
List.create( title: 'Go to Paro', description: "Go to Paro on 1st October", isComplete: true , user_id: 2)