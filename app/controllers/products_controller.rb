class ProductsController < ApplicationController
    before_action :authenticate!

    def listing
        if !current_user.admin?
            redirect_to root_path, notice: "No permission for you! � "
    end

        @products = Product.includes(:store)
    end

    def index
        respond_to do |format|
            format.json do
                if buyer?

                    @products = Product.
                        where(store_id: params[:store_id]).
                        order(:title).
                        page(page)
                end
            end
        end
    end
end
