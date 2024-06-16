class ProductsController < ApplicationController
    before_action :authenticate!
    before_action :set_locale!

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
                  page = params.fetch(:page, 1)

                    @products = Product.
                        where(store_id: params[:store_id]).
                        order(:title).
                        page(page)
                end
            end
        end
    end

    def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to @product
    else
      render 'new', status: :unprocessable_entify
    end
  end

  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to @product
    else
      render 'edit', status: :unprocessable_entify
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to products_path
  end

  private

  def product_params
    params.require(:product).permit(:name, :description, :price)
  end
end
