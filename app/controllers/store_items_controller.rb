class StoreItemsController < ApplicationController
  before_action :set_store_item, only: %i[ show edit update destroy ]

  # GET /store_items or /store_items.json
  def index
    @store_items = StoreItem.all
  end

  # GET /store_items/1 or /store_items/1.json
  def show
  end

  # GET /store_items/new
  def new
    @store_item = StoreItem.new
  end

  # GET /store_items/1/edit
  def edit
  end

  # POST /store_items or /store_items.json
  def create
    @store_item = StoreItem.new(store_item_params)

    respond_to do |format|
      if @store_item.save
        format.html { redirect_to store_item_url(@store_item), notice: "Store item was successfully created." }
        format.json { render :show, status: :created, location: @store_item }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @store_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /store_items/1 or /store_items/1.json
  def update
    respond_to do |format|
      if @store_item.update(store_item_params)
        format.html { redirect_to store_item_url(@store_item), notice: "Store item was successfully updated." }
        format.json { render :show, status: :ok, location: @store_item }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @store_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /store_items/1 or /store_items/1.json
  def destroy
    @store_item.destroy!

    respond_to do |format|
      format.html { redirect_to store_items_url, notice: "Store item was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store_item
      @store_item = StoreItem.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def store_item_params
      params.fetch(:store_item, {})
    end
end
