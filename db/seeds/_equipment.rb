if File.exist?("#{Rails.root}/db/seeds/parsed/dnd5eapi_co_equipment.rb")
  seed_file "#{Rails.root}/db/seeds/parsed/dnd5eapi_co_equipment.rb"
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
        'cost_unit' => meta.dig('cost', 'unit'),
        'cost_quantity' => meta.dig('cost', 'quantity'),
        'description' => meta['desc'].class == Array ?
          meta['desc'].map(&:inspect).join(', ') :
          meta['desc'],
        'dnd_equipment_category_id' => DnD::EquipmentCategory.
          find_by(name: meta.dig('equipment_category', 'name')).id,
        'armor_category' => meta['armor_category'],
        'armor' => meta.dig('armor_class', 'base'),
        'armor_awards_dex_bonus' => meta.dig('armor_class', 'dex_bonus'),
        'armor_has_stealth_disadvantage' =>
          meta.dig('armor_class', 'stealth_advantage'),
        'armor_strength_minimum' => meta['str_minimum'],
        'armor_bonus_maximum' => meta.dig('armor_class', 'max_bonus')
      })
    elsif meta['weapon_category']
      weapon = DnD::Weapon.new({
        'name' => meta['name'],
        'slug' => meta['index'],
        'weight' => meta['weight'],
        'cost_unit' => meta.dig('cost', 'unit'),
        'cost_quantity' => meta.dig('cost', 'quantity'),
        'description' => meta['desc'].class == Array ?
          meta['desc'].map(&:inspect).join(', ') :
          meta['desc'],
        'dnd_equipment_category_id' => DnD::EquipmentCategory.
          find_by(name: meta.dig('equipment_category', 'name')).id,
        'weapon_category' => meta['weapon_category'],
        'weapon_damage_die' => meta.dig('damage', 'damage_dice'),
        'weapon_damage_bonus' => meta.dig('damage', 'damage_bonus'),
        'weapon_range_normal' => meta.dig('range', 'normal'),
        'weapon_range_long' => meta.dig('range', 'long')
      })
      # some "weapons" don't have damage
      #   example: https://www.dnd5eapi.co/api/equipment/net
      if meta.dig('damage', 'damage_type', 'url')
        weapon['dnd_weapon_damage_type_id'] =
          DnD::DamageType.find_by(
            slug: meta.dig('damage', 'damage_type', 'url'
          ).split('/').last
        ).id
      end
      weapon.save!
    else
      DnD::Equipment.create!({
        'name' => meta['name'],
        'slug' => meta['index'],
        'weight' => meta['weight'],
        'cost_unit' => meta.dig('cost', 'unit'),
        'cost_quantity' => meta.dig('cost', 'quantity'),
        'description' => meta['desc'].class == Array ?
          meta['desc'].map(&:inspect).join(', ') :
          meta['desc'],
        'dnd_equipment_category_id' => DnD::EquipmentCategory.
          find_by(name: meta['equipment_category']['name']).id
      })
    end
    # prevent hammering
    sleep 0.2
  end

  # Go back through to update the "packs" contents
  data['results'].each do |hash|
    meta = query_api(:dnd5eapi, hash['url'])
    if meta.dig('gear_category', 'index') == 'equipment-packs'
      puts "Updating DnD::Equipment: #{meta['name']}"
      equipment_pack = DnD::Equipment.find_by(slug: meta['index'])
      meta['contents'].map do |c|
        equipment_pack.contents << DnD::Equipment.
          find_by(slug: c['item_url'].split('/').last).id
      end
      equipment_pack.save!
    end
    # prevent hammering
    sleep 0.2
  end
end
