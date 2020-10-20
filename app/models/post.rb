class Post < ApplicationRecord
  belongs_to :point
  
  mount_uploader :image1, ImageUploader    # carrierwave
  mount_uploader :image2, ImageUploader    # carrierwave
  mount_uploader :image3, ImageUploader    # carrierwave  
end
