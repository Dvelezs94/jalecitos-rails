task :reindex => [:environment] do
  reindex_list = [Gig, Request, Message, Notification, Review]
  reindex_list.each do |model|
    model.reindex
  end
  puts "reindex has finished"
end
