class Post < ApplicationRecord
  belongs_to :point
  
  validates :comment, length: { maximum: 255 }
  
  mount_uploader :image1, ImageUploader    # carrierwave
  mount_uploader :image2, ImageUploader    # carrierwave
  mount_uploader :image3, ImageUploader    # carrierwave  
end
