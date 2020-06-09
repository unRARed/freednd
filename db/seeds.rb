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

def seed_file(path)
  puts "Seeding #{path}"
  load(path)
end

#################
## API Parsing ##
#################
seed_files = []

if File.exist?("#{Rails.root}/db/seeds/dnd5eapi_co_entities.rb")
  seed_file "#{Rails.root}/db/seeds/dnd5eapi_co_entities.rb"
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


if File.exist?("#{Rails.root}/db/seeds/dnd5eapi_co_proficiencies.rb")
  seed_file "#{Rails.root}/db/seeds/dnd5eapi_co_proficiencies.rb"
else
  data = query_api(:dnd5eapi, '/api/proficiencies')
  data['results'].each do |hash|
    meta = query_api(:dnd5eapi, hash['url'])
    puts "Creating DnD::Proficiency: #{meta['name']}"
    DnD::Proficiency.create!({
      'name' => meta['name'],
      'slug' => meta['index'],
      'category' => meta['type']
    })
    # prevent hammering
    sleep 0.2
  end
end

if File.exist?("#{Rails.root}/db/seeds/open5e_com_spells.rb")
  seed_file "#{Rails.root}/db/seeds/open5e_com_spells.rb"
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
  seed_file "#{Rails.root}/db/seeds/dnd5eapi_co_features.rb"
else
  data = query_api(:dnd5eapi, '/api/features')
  data['results'].each do |hash|
    meta = query_api(:dnd5eapi, hash['url'])
    puts "Creating DnD::Feature: #{meta['name']}"
    DnD::Feature.create!({
      'name' => meta['name'],
      'slug' => meta['index'],
      'level' => meta['level'],
      'description' => meta['desc'].class == Array ?
        meta['desc'].map(&:inspect).join(', ') :
        meta['desc'],
      'dnd_class_name' => meta['class']['url'].split('/').last
    })
    # prevent hammering
    sleep 0.2
  end
end

if File.exist?("#{Rails.root}/db/seeds/dnd5eapi_co_equipment.rb")
  seed_file "#{Rails.root}/db/seeds/dnd5eapi_co_equipment.rb"
else
  data = query_api(:dnd5eapi, '/api/equipment')
  data['results'].each do |hash|
    meta = query_api(:dnd5eapi, hash['url'])
    puts "Creating DnD::Equipment: #{meta['name']}"
    if meta['armor_category']
      DnD::Armor.create!({
        'name' => meta['name'],
        'slug' => meta['index'],
        'weight' => meta['weight'],
        'cost_unit' => meta['cost']['unit'],
        'cost_quantity' => meta['cost']['quantity'],
        'description' => meta['desc'].class == Array ?
          meta['desc'].map(&:inspect).join(', ') :
          meta['desc'],
        'dnd_equipment_category_id' => DnD::EquipmentCategory.
          find_by(name: meta['equipment_category']).id,
        'armor_category' => meta['armor_category'],
        'armor' => meta['armor_class']['base'],
        'armor_awards_dex_bonus' => meta['armor_class']['dex_bonus'],
        'armor_has_stealth_disadvantage' =>
          meta['armor_class']['stealth_advantage'],
        'armor_strength_minimum' => meta['str_minimum'],
        'armor_bonus_maximum' => meta['armor_class']['max_bonus']
      })
    elsif meta['weapon_category']
      DnD::Weapon.create!({
        'name' => meta['name'],
        'slug' => meta['index'],
        'weight' => meta['weight'],
        'cost_unit' => meta['cost']['unit'],
        'cost_quantity' => meta['cost']['quantity'],
        'description' => meta['desc'].class == Array ?
          meta['desc'].map(&:inspect).join(', ') :
          meta['desc'],
        'dnd_equipment_category_id' => DnD::EquipmentCategory.
          find_by(name: meta['equipment_category']).id,
        'weapon_category' => meta['weapon_category'],
        'weapon_damage_die' => meta['damage']['damage_dice'],
        'weapon_damage_bonus' => meta['damage']['damage_bonus'],
        'weapon_range_normal' => meta['range']['normal'],
        'weapon_range_long' => meta['range']['long'],
        'dnd_weapon_damage_type_id' => DnD::DamageType.find_by(
          slug: meta['damage']['damage_type']['url'].split('/').last
        ).id
      })
    else
      DnD::Equipment.create!({
        'name' => meta['name'],
        'slug' => meta['index'],
        'weight' => meta['weight'],
        'cost_unit' => meta['cost']['unit'],
        'cost_quantity' => meta['cost']['quantity'],
        'description' => meta['desc'].class == Array ?
          meta['desc'].map(&:inspect).join(', ') :
          meta['desc'],
        'dnd_equipment_category_id' => DnD::EquipmentCategory.
          find_by(name: meta['equipment_category']).id
      })
    end
    # prevent hammering
    sleep 0.2
  end
end
byebug
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
