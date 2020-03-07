class House < ApplicationRecord
  belongs_to :investigation

  validates :house_number, presence: true, uniqueness: true
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
  
  mount_uploader :sign_pre_survey, ImageUploader    # carrierwave
  mount_uploader :sign_ongoing_survey, ImageUploader    # carrierwave
  mount_uploader :sign_after_survey, ImageUploader    # carrierwave

  mount_uploader :kyojyusya_sign_pre_survey, ImageUploader    # carrierwave
  mount_uploader :kyojyusya_sign_ongoing_survey, ImageUploader    # carrierwave
  mount_uploader :kyojyusya_sign_after_survey, ImageUploader    # carrierwave
  
  has_many :points, dependent: :destroy  # 測点（レベル）
  has_many :sonsyos, dependent: :destroy # 損傷
  has_many :keisyas, dependent: :destroy # 傾斜
end
