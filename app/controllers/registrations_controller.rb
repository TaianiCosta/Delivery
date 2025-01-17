class RegistrationsController < ApplicationController
  skip_forgery_protection only: [:create, :me, :sign_in]
  before_action :authenticate!, only: [:me]
  rescue_from User::InvalidToken, with: :not_authorized

  def me
    render json: {id: current_user.id, email: current_user.email}
  end

  def sign_in
    access = current_credential.access
    user = User.find_by(email: sign_in_params[:email])

    if !user || !user.valid_password?(sign_in_params[:password])
      render json: { message: "Nope!" }, status: 401
    else
      token = User.token_for(user)
      render json: { email: user.email, token: token }
    end
  end

  def create
    @user = User.new(user_params)
    @user.role = current_credential.access

    if @user.save
      render json: {"email": @user.email}, 
      status: :created
    else
      render json: {"Error": "unprocessable"},
      status: :unprocessable_entity
    end
  end

  private

  def user_params
    params
    .require(:user)
    .permit(:email, :password, :password_confirmation)
  end

  def sign_in_params
    params.require(:login).permit(:email, :password)
  end

  def check_token!
    if user = authenticate_with_http_token { |t, _| User.from_token(t) }
    else
      render json: {message: "Not authorized"}, status: 401
    end
  end

  def current_user
    @current_user ||= authenticate!
  end

  def not_authorized(e)
    render json: {message: "Nope!"}, status: 401
  end
end