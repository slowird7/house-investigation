class Survey < ApplicationRecord
  belongs_to :house

  validates :type, presence: true, length: { maximum: 255 }  
end