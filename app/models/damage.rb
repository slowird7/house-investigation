class Damage < ApplicationRecord
  belongs_to :sonsyo
  
  mount_uploader :image1, ImageUploader    # carrierwave
  mount_uploader :image2, ImageUploader    # carrierwave
  mount_uploader :image3, ImageUploader    # carrierwave  
end
