source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'mini_racer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test, :staging do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Random data for seeds
  gem 'faker', '~> 1.9', '>= 1.9.1'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'meta_request', '~> 0.6.0'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'bootstrap', '~> 4.2', '>= 4.2.1'
gem 'jquery-rails'
#gem 'simple-line-icons-rails', github: 'hi5dev/simple-line-icons-rails', branch: 'railties-5.2'
gem "autoprefixer-rails"
#gem 'therubyracer'
#gem 'less-rails-bootstrap'
gem 'devise', '~> 4.6', '>= 4.6.1'
gem 'devise-bootstrapped'
gem 'devise-security', '~> 0.13.0'
# Gem to export active record as diagram
gem 'railroady', '~> 1.5', '>= 1.5.3', group: :development

#Roles
gem 'petergate', '~> 1.9', '>= 1.9.1'

#Facebook login
gem 'omniauth-facebook', '~> 5.0'
# Google omniauth
gem 'omniauth-google-oauth2', '~> 0.6.1'
#Notifications
#gem 'toastr-rails'
#gem 'toastr-rails', '~> 1.0', '>= 1.0.3' #added js and css manually because this is older
#Store images
gem 'carrierwave', '~> 1.2', '>= 1.2.3'
gem 'carrierwave-aws', '~> 1.3'
#Handle images
gem 'mini_magick', '~> 4.9', '>= 4.9.2'
# AWS sdk to support role based auth and s3 files
gem 'aws-sdk', '~> 3.0', '>= 3.0.1'
# Pagination
gem 'kaminari', '~> 1.1', '>= 1.1.1'
#Text editor
# gem 'trix', '~> 0.9.5'
#Snitize data
gem 'sanitize', '~> 4.6', '>= 4.6.6'
# Friendly URLs
gem 'friendly_id', '~> 5.2', '>= 5.2.4'
#Tags
gem 'acts-as-taggable-on', '~> 6.0'
# Edit in place
gem 'best_in_place', '~> 3.1', '>= 3.1.1'
# jquery easing
gem 'jquery-easing-rails', '~> 0.0.2'
#jquery form validation
gem 'jquery-validation-rails', '~> 1.16'
#slick
# gem 'jquery-slick-rails', '~> 1.9'
#Search engine
gem 'searchkick', '~> 3.1', '>= 3.1.2'
#search autocomplete
gem 'twitter-typeahead-rails', '~> 0.11.1'
# Install event machine for DNs resolution
gem 'eventmachine', '~> 1.2', '>= 1.2.7'
# Better DNS resolution
gem 'em-resolv-replace', '~> 1.1', '>= 1.1.3'
# star system
gem 'ratyrate', '~> 1.2.2.alpha'
# Select Country code
gem 'country_select', '~> 3.1'
# Sendgrid API calls v3
gem 'sendgrid-ruby', '~> 5.3'
# PWA
gem 'serviceworker-rails', '~> 0.5.5'
# Push notifications
gem 'fcm', '~> 0.0.6'
#user profile image
gem 'jquery-fileupload-rails', '~> 1.0'
# Copy items to clipboard using JS
gem 'clipboard-rails', '~> 1.7', '>= 1.7.1'
# sidekiq for background job processing
gem 'sidekiq', '~> 5.2', '>= 5.2.5'
#carousels
# gem 'swiper-rails', '~> 1.0', '>= 1.0.4'
# Track button clicks
gem 'google-tag-manager-rails', '~> 0.1.3'
# Geocoder, get user current location
gem 'geokit-rails', '~> 2.3', '>= 2.3.1'
# Manipulate cookies
gem 'js_cookie_rails', '~> 2.2'
# captcha for signup
gem 'recaptcha', '~> 4.13', '>= 4.13.1'
# nice scroll
gem 'nicescroll-rails', '~> 3.5', '>= 3.5.4.1'
# Query places by name
gem 'google_places', '~> 1.2'
# lazy load for image tags
gem 'lazyload-rails', '~> 0.3.1'
# error detection
gem 'bugsnag', '~> 6.11', '>= 6.11.1'
# Steps
gem 'steps-rails', '~> 1.2', '>= 1.2.9'
# aws s3 driver
gem 'fog-aws', '~> 3.3'
# Sitemap generator
gem 'sitemap_generator', '~> 6.0', '>= 6.0.2'
# Cron jobs
gem 'sidekiq-cron', '~> 1.1'
# introduce the site to new people
gem 'introjs-rails', '~> 1.0'
# group items by date
gem 'groupdate', '~> 4.1', '>= 4.1.1'
# create charts
gem 'chartkick', '~> 3.0', '>= 3.0.2'
# Youtube embeded parser
gem 'youtube_rails', '~> 1.2', '>= 1.2.2'
#bot checking
gem 'voight_kampff', '~> 1.1', '>= 1.1.3'
# emojis
gem 'rails_emoji_picker', '~> 0.1.5'
#nested forms (faq of gigs)
gem 'cocoon', '~> 1.2', '>= 1.2.14'
#removes emojis, user in elasticsearch
gem 'remove_emoji', '~> 1.0'
#styling of data confirm links
gem 'data-confirm-modal', '~> 1.6', '>= 1.6.3'
