# app/controllers/api/v1/users_controller.rb
module Api
  module V1
    class UsersController < ApplicationController
      # Ensure only logged-in users can access these routes
      before_action :authenticate_request!

      # GET /api/v1/me
      # Returns current logged-in user details (based on JWT token)
      def me
        render json: {
          id: current_user.id,
          name: current_user.name,
          email: current_user.email,
          role: current_user.role
        }, status: :ok
      end

      # (Optional) In the future, you can expand this controller:
      # - update profile (PATCH /api/v1/me)
      # - list all users (admin-only)
      # - change password, etc.
    end
  end
end
