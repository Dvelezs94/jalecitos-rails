module GigsHelper
  def image_display_helper image
    if image.nil?
      "http://placehold.it/600x400"
    else
      image
    end
  end
end
