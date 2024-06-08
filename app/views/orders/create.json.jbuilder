json.order do
    json.id @order.id
end

json.array! @orders, :id, :state, :created_at