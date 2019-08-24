class Survey < ApplicationRecord
  belongs_to :house

  validates :survey_name, presence: true, length: { maximum: 255 }
  validates :overview, length: { maximum: 255 }
  validates :range, length: { maximum: 255 }
  
  has_many :points
end