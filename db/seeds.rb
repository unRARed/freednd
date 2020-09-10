# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Utility function for fetching data from DnD 5e API Resources
def query_api(api, endpoint)
  api_map = {
    open5e: 'https://api.open5e.com', #/spells/?format=json&page=7
    dnd5eapi: 'https://www.dnd5eapi.co'
  }
  url = URI(api_map[api] + endpoint)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  api_request = Net::HTTP::Get.new(url)
  api_response = http.request(api_request)
  JSON.parse(api_response&.body)
end

#################
## API Parsing ##
#################

# To limit consumption of external APIs,
# use seed_dump to persist the data:
#   rake db:seed:dump MODELS="Model1, Model2" \
#     FILE=db/seeds/parsed/SOURCE_table.rb
def seed_file(path)
  puts "Seeding #{path}"
  load(path)
end

seed_file('./db/seeds/_entities.rb')
seed_file('./db/seeds/_proficiencies.rb')
seed_file('./db/seeds/_spells.rb')
seed_file('./db/seeds/_features.rb')
seed_file('./db/seeds/_equipment.rb')

unless Rails.env.production?
  puts "Creating Dummy Data"
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
    race: 'Human',
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
end
