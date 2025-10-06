# app/controllers/api/v1/auth_controller.rb
class Api::V1::AuthController < ApplicationController
  # skip_before_action :verify_authenticity_token if you're using API mode and testing from curl/postman

  def signup
    user = User.new(user_params)
    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      # Optionally set HttpOnly cookie:
      # cookies.signed[:jwt] = { value: token, httponly: true, secure: Rails.env.production? }

      render json: { token: token, user: user.as_json(only: [:id, :name, :email, :role]) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def login
    user = User.find_by(email: login_params[:email])
    if user&.authenticate(login_params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      # cookies.signed[:jwt] = { value: token, httponly: true, secure: Rails.env.production? }
      render json: { token: token, user: user.as_json(only: [:id, :name, :email, :role]) }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  private

  # Accept both top-level and nested "auth" key
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
