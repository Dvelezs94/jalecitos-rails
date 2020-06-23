task :close_requests => [:environment] do
  puts "Closing old requests..."
  Request.all.each do |request|
    request.closed! if Time.now > (request.created_at + 30.days) && request.published?
  end
  puts "Task finished"
end
