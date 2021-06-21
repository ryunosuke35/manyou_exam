# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create(
  name: '松村龍之介',
  email: 'matsumura@gmail.com',
  password: 'asdf123',
  password_confirmation: 'asdf123',
  admin:'true'
)

(2..5).each do |n|
  User.create(
    name: "松村龍之介#{n}",
    email:"matsumura#{n}@gmail.com",
    password: 'asdf123',
    password_confirmation: 'asdf123',
    admin:'false'
  )
end
