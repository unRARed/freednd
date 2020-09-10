if File.exist?("#{Rails.root}/db/seeds/parsed/dnd5eapi_co_entities.rb")
  seed_file "#{Rails.root}/db/seeds/parsed/dnd5eapi_co_entities.rb"
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
