class Point < ApplicationRecord
  belongs_to :house
  
  has_many :posts, dependent: :destroy
end
