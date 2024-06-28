class Product < ApplicationRecord
  belongs_to :store
  has_many :orders, through: :order_items
  has_many :order_items

  validates :title, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }

  scope :active, -> { where(deleted: false) }
  scope :deleted, -> { where(deleted: true) }

  def soft_delete
    update(deleted: true)
  end

  def undelete
    update(deleted: false)
  end
end
