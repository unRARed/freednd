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
seed_files = []

if File.exist?("#{Rails.root}/db/seeds/dnd5eapi_co_entities.rb")
  seed_files << "#{Rails.root}/db/seeds/dnd5eapi_co_entities.rb"
else
  [
    ['Condition', 'conditions'],
    ['School', 'magic-schools'],
    ['EquipmentCategory', 'equipment-categories'],
    ['DamageType', 'damage-types'],
    ['WeaponProperty', 'weapon-properties'],
    ['Ability', 'ability-scores'],
    ['Skill', 'skills']
  ].each do |arr|
    data = query_api(:dnd5eapi, "/api/#{arr[1]}")
    data['results'].each do |hash|
      meta = query_api(:dnd5eapi, hash['url'])
      puts "Creating DnD::#{arr[0]}: #{meta['name']}"
      "DnD::#{arr[0]}".constantize.create!({
        'name' => meta['name'],
        'slug' => meta['index'],
        'description' => meta['desc'].class == Array ?
          meta['desc'].map(&:inspect).join(', ') :
          meta['desc'],
        'parent_entity_id' => meta['ability_score'] ?
          DnD::Ability.find_by(name: meta['ability_score']['name']).id :
          nil
      })
      # prevent hammering
      sleep 0.2
    end
  end
end

if File.exist?("#{Rails.root}/db/seeds/open5e_com_spells.rb")
  seed_files << "#{Rails.root}/db/seeds/open5e_com_spells.rb"
else
  while true
    ('1'...'9999').to_a.each do |page|
      data = query_api(:open5e, "/spells/?format=json&page=#{page}")
      break unless data['results']

      data['results'].each do |meta|
        puts "Creating DnD::Spell: #{meta['name']}"
        DnD::Spell.create! meta.
          slice(*DnD::Spell.new.attributes.keys).
          merge(
            'slug' => meta['slug'],
            'school' => meta['school']['name'],
            'description' => meta['desc'],
            'dnd_classes' => meta['dnd_class'],
            'archetypes' => meta['archetype'],
            'level' => meta['level_int'],
            'level_conditions' => meta['higher_level'],
            'requires_concentration' => (meta['concentration'] == 'yes'),
            'components' => meta['components'],
            'is_ritual' => (meta['ritual'] == 'yes')
          )
        sleep 0.2
      end
    end
    break
  end
end

if File.exist?("#{Rails.root}/db/seeds/dnd5eapi_co_features.rb")
  seed_files << "#{Rails.root}/db/seeds/dnd5eapi_co_features.rb"
else
  data = query_dnd5eapi('/api/features')
  spells_data = []
  data['results'].each do |hash|
    meta = query_dnd5eapi(hash['url'])
    puts "Creating DnD::Feature: #{meta['name']}"
    DnD::Feature.create!({
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
