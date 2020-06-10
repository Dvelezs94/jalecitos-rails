require 'carrierwave/storage/fog'

CarrierWave.configure do |config|
  if Rails.env.test? || Rails.env.development?
    config.storage = :file
    config.enable_processing = false
    config.root = "public/uploads/tmp/"
    config.base_path = "/uploads/tmp"
  else
    config.fog_provider = 'fog/aws'
    config.storage = :fog
    config.fog_directory = ENV.fetch('S3_BUCKET_NAME') {""}                 # required
    config.fog_public    = true
    config.fog_attributes = { 'Cache-Control': 'max-age=315576000' }

    config.fog_credentials = {
      provider:              'AWS',                            # required
      region:                ENV.fetch('AWS_REGION') {'us-east-1'},
      use_iam_profile:       true
    }



    # store files locally in test and development environments
  end
end
