# Set the host name for URL creation
SitemapGenerator::Interpreter.send :include, ApplicationHelper
SitemapGenerator::Sitemap.default_host = "https://www.jalecitos.com"
SitemapGenerator::Sitemap.compress = false
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new(fog_provider: 'AWS',
                                                                    use_iam_profile: true,
                                                                    fog_directory: ENV.fetch('S3_BUCKET_NAME') {""},
                                                                    fog_region: ENV.fetch('AWS_REGION') {""})

SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.sitemaps_host = "https://#{ENV.fetch('S3_BUCKET_NAME') {""}}.s3.amazonaws.com/"
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
    Gig.all.pluck(:address_name).uniq.each do |address_seo|
      add search_path(query: profession.name, address_seo: address_seo)
    end
  end
  Category.all.each do |cat|
    add search_path(category_name: cat.name, category_id: cat.id)
  end

  add '/trabaja'
end
