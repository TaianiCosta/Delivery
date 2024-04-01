class Store < ApplicationRecord
    belongs_to :user, optional: true
    validates :name, presence: true, length: {minimum: 3}
end
