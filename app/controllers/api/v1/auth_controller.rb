# app/controllers/api/v1/auth_controller.rb
class Api::V1::AuthController < ApplicationController
  # skip CSRF if API testing via curl/postman
  # skip_before_action :verify_authenticity_token

  def signup
    user = User.new(user_params)

    if user.save
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: user.as_json(only: [:id, :name, :email, :role]) }, status: :created
    else
      Rails.logger.info("[Signup failed] errors=#{user.errors.full_messages.join(', ')} params=#{user_params.to_h}")
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotUnique => e
    Rails.logger.error("[Signup DB unique constraint] #{e.message}")
    render json: { errors: ["Email already exists (unique constraint)"] }, status: :conflict
  rescue => e
    Rails.logger.error("[Signup unexpected error] #{e.class}: #{e.message}\n#{e.backtrace[0..5].join("\n")}")
    render json: { errors: ["Internal server error"] }, status: :internal_server_error
  end

  private

  def raw_params
    params[:auth].present? ? params.require(:auth).permit(:name, :email, :password, :role) : params.permit(:name, :email, :password, :role)
  end

  def user_params
    raw_params
  end
end
