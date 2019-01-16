task :reindex => [:environment] do
  reindex_list = [Gig, Request, Message, Notification, Review, User, Order, Profession]
  reindex_list.each do |model|
    model.reindex
  end
  puts "reindex has finished"
end
