module Api
  module V1
    module Auth
      class ProfilesController < ApplicationController
        include Authenticatable

        def show
          render json: { data: { user: UserSerializer.new(current_user).as_json } }
        end
      end
    end
  end
end
