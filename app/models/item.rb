class Item < ApplicationRecord
  belongs_to :category

  validates :name, presence: true, length: { maximum: 50, minimum: 2 }
  validates :amount, presence: true, numericality: { greater_than: 0 }
end
