task :gig_lowest_price => [:environment] do
  Gig.all.each do |gig|
    gig.update_columns(lowest_price: gig.gig_packages.first.lowest_price) if gig.gig_packages.any? && gig.gig_packages.first.price.present?
  end
  puts "All the first package prices have been saved on gig lowest price column"
end
