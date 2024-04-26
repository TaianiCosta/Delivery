require "rails_helper"

RSpec.describe "/stores", type: :request do
    describe "GET / show" do
        let(:user) {
          user = User.new(
            email: "user@example.com",
            password: "123456",
            password_confirmation: "123456",
            role: "seller"
          )
          user.save!
          user
        }

        before {
          sign_in(user)
        }

        it "renders a successful response with stores data" do
        store = Store.create! name: "New Store", user: user
          get "/store/#{store.id}", headers: {"Accept" => "application/json", "Authorization" => "Bearer #{signed_in["token"]}"
          }          
          json = JSON.parse(response.body)
    
          expect(json["name"]).to eq "New Store"
        end
    end
end