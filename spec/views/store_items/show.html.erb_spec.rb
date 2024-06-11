require 'rails_helper'

RSpec.describe "store_items/show", type: :view do
  before(:each) do
    assign(:store_item, StoreItem.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
