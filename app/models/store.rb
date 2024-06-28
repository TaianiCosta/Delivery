class Store < ApplicationRecord
    belongs_to :user
    before_validation :ensure_seller
    validates :name, presence: true, length: {minimum: 3}
    has_many :products
    
    def deactivate!
        update(active: false)
    end
    
    def soft_delete
        update(deleted: true)
    end
    
    def undelete
        update(deleted: false)
    end
    
    def image_url
        Rails.application.routes.url_helpers.rails_blob_url(image, host: "localhost:3000") if image.attached?
    end

    private
    
    def ensure_seller
        self.user = nil if self.user && !self.user.seller?
    end
end
