class Investigation < ApplicationRecord
  validates :content, presence: true, length: { maximum: 255 }
  validates :construction_name, presence: true, length: { maximum: 255 }
  validates :builder, presence: true, length: { maximum: 255 }
  validates :investigator, presence: true, length: { maximum: 255 }
  validates :place, presence: true, length: { maximum: 255 }

  has_many :houses
end