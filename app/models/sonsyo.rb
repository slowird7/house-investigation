class Sonsyo < ApplicationRecord
  belongs_to :house
  
  has_many :damages, dependent: :destroy
end
