class User < ApplicationRecord
    enum :role, [:admin, :seller, :buyer]
        has_many :stores
        
        # Include default devise modules. Others available are:
        # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
        devise :database_authenticatable, :registerable,
            :recoverable, :rememberable, :validatable


    def self.from_token(token)
        decoded = JWT.decode(
            token, "muito.secreto", true, {algorithm: "HS256"}
        )
        user_data = decoded[0].with_indifferent_access
        User.find(user_data[:id])
    end
end