# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

seed_files = []
if File.exist?("#{Rails.root}/db/seeds/dnd5eapi_co_spells.rb")
  seed_files << "#{Rails.root}/db/seeds/dnd5eapi_co_spells.rb"
else
  data = query_dnd5eapi('/api/spells')
  spells_data = []
  data['results'].each do |hash|
    meta = query_dnd5eapi(hash['url'])
    puts "Creating Spell: #{meta['name']}"
    Spell.create! meta.
      slice(*Spell.new.attributes.keys).
      merge(
        'slug' => meta['index'],
        'school' => meta['school']['name'],
        'description' => meta['desc'].map(&:inspect).join(', '),
        'dnd_classes' => meta['classes'].map{|c| c['name']}.join(', '),
        'level_conditions' => meta['higher_level']&.
          map(&:inspect)&.join(', '),
        'requires_concentration' => meta['concentration'],
        'components' => meta['components']&.map(&:inspect)&.join(', '),
        'is_ritual' => meta['ritual']
      )
    sleep 0.2
  end
end

if File.exist?("#{Rails.root}/db/seeds/dnd5eapi_co_features.rb")
  seed_files << "#{Rails.root}/db/seeds/dnd5eapi_co_features.rb"
else
  data = query_dnd5eapi('/api/features')
  spells_data = []
  data['results'].each do |hash|
    meta = query_dnd5eapi(hash['url'])
    puts "Creating Feature: #{meta['name']}"
    Feature.create!({
      'name' => meta['name'],
      'level' => meta['level'],
      'dnd_class' => meta['class']['name'],
      'description' => meta['desc'].map(&:inspect).join(', ')
    })
    # prevent hammering
    sleep 0.2
  end
end

if seed_files.any?
  seed_files.each do |path_to_seed_file|
    puts "Seeding #{path_to_seed_file}"
    load(path_to_seed_file)
  end
end

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

# Utility function for getting data from https://www.dnd5eapi.co/
def query_dnd5eapi(endpoint)
  url = URI('https://www.dnd5eapi.co' + endpoint)
  http = Net::HTTP.new(url.host, url.port)
  http.use_ssl = true
  http.verify_mode = OpenSSL::SSL::VERIFY_PEER
  api_request = Net::HTTP::Get.new(url)
  api_response = http.request(api_request)
  JSON.parse(api_response&.body)
end
