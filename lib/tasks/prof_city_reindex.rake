task :reindex => [:environment] do
  reindex_list = [Profession, City]
  reindex_list.each do |model|
    model.reindex
  end
  puts "reindex has finished"
end
