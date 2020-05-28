# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

users = []
(1..3).to_a.map do |n|
  users << User.create!(email: "user#{n}@freednd.com", password: 'pw')
end
puts "Created #{users.count} Users"

campaign = Campaign.create! user: users.first,
  name: 'Some Awesome Campaign',
  description: 'Lorem ipsum dolor sit amet, consectetur adipiscing
    elit. Duis commodo dapibus luctus. In gravida velit lorem,
    vitae consectetur augue sodales et. Cras fermentum lacus
    accumsan finibus tempor. Suspendisse blandit fringilla erat,
    eget aliquam leo imperdiet vitae.'
puts 'Created Campaign'

shared_attributes = {
  dnd_class: 'Bard',
  race: 'Druid',
  background: 'Outlander',
  alignment: 'Lawful Good'
}

party = Party.create! campaign: campaign
puts "Created Party"

chars = []
users.map do |user|
  chars << Character.create!({
    user: user,
    name: "Char#{user.id}" }.merge(shared_attributes)
  )
  chars.map{|char| char.progressions.create party: party }
end
puts "Created #{chars.count} Characters in Party"

