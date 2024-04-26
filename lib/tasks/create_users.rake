namespace :user do
    desc "Create default users"
    task create: :environment do
      ["Aracelis Weissnat", "Pasquale Wisozk"].each do |buyer|
        email = buyer.split.map { |s| s.downcase }.join(".") + "@example.com"
        user = User.find_by(email: email)
        unless user
          user = User.new(
            email: email,
            password: "123456",
            password_confirmation: "123456",
            role: :buyer
          )
          user.save!
        end
      end
    end
  end
  