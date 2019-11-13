class Keisya < ApplicationRecord
  belongs_to :house
  
  has_many :slopes, dependent: :destroy  
end
