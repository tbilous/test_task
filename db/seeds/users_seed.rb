
10.times do
  User.create!(email: Faker::Internet.unique.email,
               password: 'foobar',
               password_confirmation: 'foobar')
end
Faker::Internet.unique.clear
