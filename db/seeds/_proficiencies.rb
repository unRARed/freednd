if File.exist?("#{Rails.root}/db/seeds/parsed/dnd5eapi_co_proficiencies.rb")
  seed_file "#{Rails.root}/db/seeds/parsed/dnd5eapi_co_proficiencies.rb"
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
