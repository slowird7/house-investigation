class User < ApplicationRecord
#    before_save { self.email.downcase! }
#    validates :email, presence: true, length: { maximum: 255 },
#                      format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
#                      uniqueness: { case_sensitive: false }
  validates :role, presence: true, length: { maximum: 50 }
  validates :user_name, presence: true, uniqueness: true, length: { maximum: 16 }, format: { with: /\A[a-zA-Z0-9]+\z/i }

  has_secure_password
end