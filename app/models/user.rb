class User < ApplicationRecord
  class InvalidToken < StandardError; end

  enum :role, [:admin, :seller, :buyer]
  has_many :stores
  validates :role, presence: true

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  JWT_SECRET = Rails.application.credentials.secret_key_base
      
  def self.from_token(token)
    decoded = JWT.decode(token, "muito secreto", true, { algarithm: "HS256" })
    user_data = decoded[0].with_indifferent_access
    user = User.find_by(id: user_data[:id])

    if user 
      user.email = user_data[:email]
      user.role = user_data[:role]
      user.save
    end
  rescue JWT::ExpiredSignature
    raise InvalidToken.new
  end

  def self.token_for(user)
    jwt_headers = {exp: 1.hour.from_now.to_i}
    payload = {id: user.id, email: user.email, role: user.role}
    JWT.encode(payload.merge(jwt_headers), "muito.secreto", "HS256")
  end

  validates :role, presence: true
end
