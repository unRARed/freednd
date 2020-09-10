if File.exist?("#{Rails.root}/db/seeds/parsed/dnd5eapi_co_features.rb")
  seed_file "#{Rails.root}/db/seeds/parsed/dnd5eapi_co_features.rb"
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

