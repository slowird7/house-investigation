class House < ApplicationRecord
  belongs_to :investigation
  
  validates :house_name, presence: true, length: { maximum: 255 }
  validates :prefectures, presence: true, length: { maximum: 255 }
  validates :city, length: { maximum: 255 }
  validates :block, length: { maximum: 255 }
  validates :resident_phone_number, length: { maximum: 255 }
  
  validates :owner_name, length: { maximum: 255 }
  validates :owner_prefectures, length: { maximum: 255 }
  validates :owner_city, length: { maximum: 255 }
  validates :owner_block, length: { maximum: 255 }
  validates :owner_phone_number, length: { maximum: 255 }
  
  validates :construction, length: { maximum: 255 }
  validates :floors, length: { maximum: 255 }
  validates :area, length: { maximum: 255 }
  validates :use, length: { maximum: 255 }
  
  has_many :points
end
