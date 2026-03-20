module Api
  module V1
    module Auth
      class RegistrationsController < ApplicationController
        def create
          user = User.create!(registration_params)

          render json: {
            data: {
              user: UserSerializer.new(user).as_json,
              token: ::Auth::TokenIssuer.call(user:)
            }
          }, status: :created
        end

        private

        def registration_params
          params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
        end
      end
    end
  end
end
