class GigUploader < CarrierWave::Uploader::Base
  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
   include CarrierWave::MiniMagick

   #resize uploaded image
   #process resize_to_fit: [600, 400]
  # Choose what kind of storage to use for this uploader:
  if Rails.env.test? || Rails.env.development?
    storage :file
  else
    storage :fog
  end

  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:

  def store_dir
    "#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
  #single image size
  def size_range
    1..10.megabytes
  end
  def filename
    "#{original_filename}" if original_filename
  end
  def extension_whitelist
    %w(jpg jpeg png gif)
  end

  # Permissions for file upload
  def aws_acl
    "public-read"
  end
  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # configure do |config|
  #   config.remove_previously_stored_files_after_update = false
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  version :carousel, :if => :not_gif?  do #we dont resize the gifs
    process resize_to_fill: [250, 200]
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  protected
  def not_gif?(new_file)
    !new_file.content_type.include? 'gif'
  end

end
