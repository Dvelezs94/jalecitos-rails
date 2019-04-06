task :reindex => [:environment] do
  reindex_list = [Gig, Request, User, Profession, City]
  reindex_list.each do |model|
    model.reindex
  end
  puts "reindex has finished"
end


task :reindex_prof_city => [:environment] do
  reindex_list = [Profession, City]
  reindex_list.each do |model|
    model.reindex
  end
  puts "reindex has finished"
end
