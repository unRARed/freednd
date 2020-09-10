if File.exist?("#{Rails.root}/db/seeds/parsed/open5e_com_spells.rb")
  seed_file "#{Rails.root}/db/seeds/parsed/open5e_com_spells.rb"
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

