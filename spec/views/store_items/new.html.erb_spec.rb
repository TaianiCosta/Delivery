require 'rails_helper'

RSpec.describe "store_items/new", type: :view do
  before(:each) do
    assign(:store_item, StoreItem.new())
  end

  it "renders new store_item form" do
    render

    assert_select "form[action=?][method=?]", store_items_path, "post" do
    end
  end
end
