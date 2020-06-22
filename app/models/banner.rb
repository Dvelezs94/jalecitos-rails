class Banner < ApplicationRecord
  mount_uploader :image, BannerUploader

  def get_image_height_and_width
    image = MiniMagick::Image.open(avatar.path)
    return [image[:width],image[:height]]
  end
end
