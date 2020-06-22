class Banner < ApplicationRecord

  #before_update :recursive_display
  mount_uploader :image, BannerUploader

  def wd #get height and width
    image2 = MiniMagick::Image.open(image.path)
    return [image2[:width],image2[:height]]
  end

  def recursive_display
    if display != 0
      banner2 = Banner.where(display: display).where.not(id: id)
      banner2.update(display: display+1) if banner2.present?
    end
  end

  def greather_than_zero
    display > 0
  end

end
