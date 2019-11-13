class Slope < ApplicationRecord
  belongs_to :keisya
  
  mount_uploader :image1, ImageUploader    # carrierwave
  mount_uploader :image2, ImageUploader    # carrierwave
  mount_uploader :image3, ImageUploader    # carrierwave    
end
