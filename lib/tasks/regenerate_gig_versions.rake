namespace :regen_gig_images do
  desc "REGEN"
  task :recreate => :environment do
    Gig.all.each do |gig|
      gig.images.each do |img|
        img.recreate_versions!
      end
    end
  end
end
