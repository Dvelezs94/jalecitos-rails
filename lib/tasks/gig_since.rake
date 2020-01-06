task :gig_since => [:environment] do
  Gig.all.each do |gig|
    gig.update_columns(since: gig.gig_packages.first.starting_price) if gig.gig_packages.any? && gig.gig_packages.first.price.present?
  end
  puts "All the first package prices have been saved on gig since column"
end
