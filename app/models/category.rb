class Category < ApplicationRecord
  has_many :items, dependent: :destroy

  validates :title, presence: true, length: { maximum: 50, minimum: 2 }
end
