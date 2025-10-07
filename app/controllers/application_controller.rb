# app/controllers/application_controller.rb
class ApplicationController < ActionController::API
  before_action :set_default_format

  private

  def set_default_format
    request.format = :json
  end

  # Reads Authorization: Bearer <token>
  def authenticate_request!
    header = request.headers['Authorization']
    token = header.split(' ').last if header.present?
    decoded = JsonWebToken.decode(token)

    if decoded && decoded['user_id']
        @current_user = User.find_by(id: decoded['user_id'])
    end

    render json: { error: 'Not Authorized' }, status: :unauthorized unless @current_user
    rescue JWT::ExpiredSignature, JWT::DecodeError
    render json: { error: 'Invalid or expired token' }, status: :unauthorized
    end
end
