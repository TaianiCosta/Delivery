require 'rails_helper'

RSpec.describe "store_items/edit", type: :view do
  let(:store_item) {
    StoreItem.create!()
  }

  before(:each) do
    assign(:store_item, store_item)
  end

  it "renders the edit store_item form" do
    render

    assert_select "form[action=?][method=?]", store_item_path(store_item), "post" do
    end
  end
end
