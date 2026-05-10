module Api
  module V1
    module Auth
      class OnboardingsController < ApplicationController
        include Authenticatable

        def update
          role = params.dig(:user, :role)

          unless %w[runner organizer].include?(role.to_s)
            return render json: { errors: ["Invalid role specified"] }, status: :bad_request
          end

          if current_user.update(role: role)
            render json: { data: { user: UserSerializer.new(current_user).as_json } }, status: :ok
          else
            render json: { errors: current_user.errors.full_messages }, status: :unprocessable_entity
          end
        end
      end
    end
  end
end
