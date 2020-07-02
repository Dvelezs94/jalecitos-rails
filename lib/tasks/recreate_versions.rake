task :recreate_versions => [:environment] do
  Gig.all.each do |gig|
    gig.images.each do |image|
      image.recreate_versions!
    end
  end
  Request.all.each do |req|
    req.images.each do |image|
      image.recreate_versions!
    end
  end
  puts "recreated all versions!"
end
