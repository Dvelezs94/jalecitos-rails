task :reindex => [:environment] do
  reindex_list = [Gig, Request, Message, Notification, Review, User, Order, Profession, Like]
  reindex_list.each do |model|
    model.reindex
  end
  puts "reindex has finished"
end
