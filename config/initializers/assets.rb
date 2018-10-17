# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
################js
Rails.application.config.assets.precompile += %w( google_functions.js )

Rails.application.config.assets.precompile += %w( page.js )

Rails.application.config.assets.precompile += %w( gig.js )

Rails.application.config.assets.precompile += %w( request.js )

Rails.application.config.assets.precompile += %w( admin.js )

Rails.application.config.assets.precompile += %w( conversation.js )

Rails.application.config.assets.precompile += %w( tag.js )

Rails.application.config.assets.precompile += %w( user.js )
###################css
Rails.application.config.assets.precompile += %w( gig.scss )

Rails.application.config.assets.precompile += %w( page.scss )

Rails.application.config.assets.precompile += %w( page-styles.scss )

Rails.application.config.assets.precompile += %w( request.scss )

Rails.application.config.assets.precompile += %w( admin.scss )

Rails.application.config.assets.precompile += %w( conversation.scss )

Rails.application.config.assets.precompile += %w( user.scss )

# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
