module Api
  module V1
    module Auth
      class SessionsController < ApplicationController
        include Authenticatable

        skip_before_action :authenticate_user!, only: :create

        def create
          user = User.find_by(email: login_params[:email].to_s.downcase)

          unless user&.authenticate(login_params[:password])
            return render_error(code: "invalid_credentials", message: "Invalid email or password", status: :unauthorized)
          end

          render json: {
            data: {
              user: UserSerializer.new(user).as_json,
              token: ::Auth::TokenIssuer.call(user:)
            }
          }
        end

        def destroy
          current_user.increment!(:token_version)
          head :no_content
        end

        private

        def login_params
          params.require(:session).permit(:email, :password)
        end
      end
    end
  end
end
