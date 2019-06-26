class House < ApplicationRecord
  belongs_to :investigation
  
  validates :house_name, presence: true, length: { maximum: 255 }
  validates :prefectures, presence: true, length: { maximum: 255 }
  validates :city, presence: true, length: { maximum: 255 }
  validates :block, length: { maximum: 255 }
  validates :owner, presence: true, length: { maximum: 255 }  
end
