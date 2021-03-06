# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path
# Add Yarn node_modules folder to the asset load path.
Rails.application.config.assets.paths << Rails.root.join('node_modules')

# Precompile additional assets.
################js
Rails.application.config.assets.precompile += %w( logged.js )

Rails.application.config.assets.precompile += %w( guest.js )

Rails.application.config.assets.precompile += %w( admin.js )

Rails.application.config.assets.precompile += %w( google_turbolink.js )

Rails.application.config.assets.precompile += %w( lazy_load.js )

###################css
Rails.application.config.assets.precompile += %w( logged.scss )

Rails.application.config.assets.precompile += %w( guest.scss )

Rails.application.config.assets.precompile += %w( admin.scss )

Rails.application.config.assets.precompile += %w( mobile.css )



# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.configuration.assets.precompile += %w[firebase-messaging-sw.js manifest.json]
