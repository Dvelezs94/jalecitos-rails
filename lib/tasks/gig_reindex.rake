task :gig_reindex => [:environment] do
  reindex_list = [Gig]
  reindex_list.each do |model|
    model.reindex
  end
  puts "gig reindex has finished"
end
