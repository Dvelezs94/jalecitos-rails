class Banner < ApplicationRecord

  mount_uploader :image, BannerUploader

  def wd #get height and width
    image2 = MiniMagick::Image.open((ENV.fetch("RAILS_ENV") == "production")? image.url : image.path)
    return [image2[:width],image2[:height]]
  end


  def greather_than_zero
    display > 0
  end

  def url_with_protocol
    u = URI.parse(self.url)
    if(!u.scheme)
      "https://#{self.url}"
    elsif(%w{http https}.include?(u.scheme))
      self.url
    end
  end

end
