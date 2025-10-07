# app/controllers/api/v1/auth_controller.rb
class Api::V1::AuthController < ApplicationController
  # signup and login are public, so do not call authenticate_request!
  def signup
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: UserSerializer.new(user) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique => e
    render json: { errors: ['Email already exists'] }, status: :conflict
  end

  def login
    user = User.find_by(email: login_params[:email])
    if user&.authenticate(login_params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: UserSerializer.new(user) }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  def raw_params
    params[:auth].present? ? params.require(:auth).permit(:name, :email, :password, :role) : params.permit(:name, :email, :password, :role)
  end

  def user_params
    raw_params
  end

  def login_params
    params[:auth].present? ? params.require(:auth).permit(:email, :password) : params.permit(:email, :password)
  end
end
