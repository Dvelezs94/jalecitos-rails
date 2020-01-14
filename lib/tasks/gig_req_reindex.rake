task :gig_req_reindex => [:environment] do
  reindex_list = [Gig, Request]
  reindex_list.each do |model|
    model.reindex
  end
  puts "gig and request reindex has finished"
end
