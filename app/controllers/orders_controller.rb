class OrdersController < ApplicationController
    skip_forgery_protection
    before_action :authenticate!
    before_action :only_buyers!

    
    def create
        @order = Order.new(order_params)
        @order.buyer = current_user if current_user.buyer?

        respond_to do |format|
            if @order.save
                payment_params = {
                number: params[:number],
                valid: params[:valid],
                cvv: params[:cvv].to_i
                }
                process_payment(@order, payment_params)

                format.html { redirect_to order_url(@order), notice: 'Pedido criado. Processando o pagamento.' }
                format.json { render :create, status: :created }
            else
                format.html { render :new, status: :unprocessable_entity }
                format.json { render json: @order.errors, status: :unprocessable_entity }
            end
        end
    end

    # GET /buyers/orders
    def index
        @orders = orders_for(current_user)
    end

    # GET /buyers/orders/1
    def show; end

    # GET /buyers/orders/new
    def new
        @order = Order.new
        @order.order_items.build
        @stores = Store.kept

        return unless current_user.admin?

        @buyers = User.kept.where(role: :buyer)
    end

    # State machine events
    def accept_order
        return unless @order.accept

        @order.save
        render json: { order_status: @order.state, message: 'Pedido aceito.' }
    end

    def order_ready_for_pickup
        return unless @order.ready_for_pickup

        @order.save
        render json: { order_status: @order.state, message: 'Pedido pronto.' }
    end

    def dispatch_order
        return unless @order.dispatch

        @order.save
        render json: { order_status: @order.state, message: 'Pedido saiu para entrega.' }
    end

    def deliver_order
        return unless @order.deliver

        @order.save
        render json: { order_status: @order.state, message: 'Pedido entregue.' }
    end

    def cancel_order
        return unless @order.cancel

        @order.save
        render json: { order_status: @order.state, message: 'Pedido cancelado.' }
    end

    private

    def order_params
        params.require(:order).permit([:store_id])
    end
end