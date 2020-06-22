class Banner < ApplicationRecord
  mount_uploader :image, BannerUploader
end
