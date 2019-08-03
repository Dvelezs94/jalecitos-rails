# Set the host name for URL creation
SitemapGenerator::Interpreter.send :include, ApplicationHelper
SitemapGenerator::Sitemap.default_host = "https://www.jalecitos.com"
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(fog_provider: 'AWS',
                                                                    aws_access_key_id: ENV.fetch('AWS_ACCESS_KEY_ID'),
                                                                    aws_secret_access_key: ENV.fetch('AWS_SECRET_ACCESS_KEY'),
                                                                    fog_directory: ENV.fetch('S3_BUCKET_NAME'),
                                                                    fog_region: ENV.fetch('AWS_REGION'))

SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_host = "https://#{ENV.fetch('S3_BUCKET_NAME')}.s3.amazonaws.com/"
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'
SitemapGenerator::Sitemap.ping_search_engines('https://www.jalecitos.com/sitemap')
SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  add root_path, :changefreq => 'daily'

  Gig.published.find_each do |gig|
    add the_gig_path(gig), :lastmod => gig.updated_at
  end

  User.active.find_each do |user|
    add user_path(user.slug), :lastmod => user.updated_at
  end

  Profession.all.each do |profession|
    City.all.each do |city|
      add search_path(query: profession.name, city: city.name, state: city.state.name)
    end
  end

  add '/trabaja'
end
