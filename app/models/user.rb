class User < ApplicationRecord
  has_many :items, dependent: :destroy

  validates :name, presence: true, length: { maximum: 50, minimum: 5 }

  validates :email, presence: true, length: { maximum: 50, minimum: 5 },
                    uniqueness: { case_sensitive: false },
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, message: 'Email invalid' }

  has_secure_password
  validates :password_digest, presence: true, length: { maximum: 1024, minimum: 5 }
end
