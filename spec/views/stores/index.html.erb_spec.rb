require 'rails_helper'

RSpec.describe "stores/index", type: :view do
  let(:user) {
    user = User.new(
      email: "user@example.com", 
      password: "123456", 
      password_confirmation: "123456", 
      role: :seller
      )
      user.save!
      user 
    }

  before(:each) do
    assign(:stores, [Store.create!(name: "Store 1", user: user), Store.create!(name: "Store 2", user: user)])
  end

  skip it "renders a list of stores" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Store Name".to_s), count: 2
  end
end