task :old_elastic => [:environment] do
  models = [Notification, Order, Review, Like, Message]

  models.each do |model|
    model.search_index.delete
  end
  puts "finished removing indexes of elastic"
end
