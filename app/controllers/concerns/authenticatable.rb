module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  private

  def authenticate_user!
    token = bearer_token
    payload = ::Auth::JsonWebToken.decode(token)

    @current_user = User.find(payload.fetch("sub"))

    return if @current_user.token_version == payload.fetch("token_version")

    raise ::Auth::AuthenticationError, "Token is no longer valid"
  rescue KeyError, ActiveRecord::RecordNotFound, ::Auth::AuthenticationError => error
    render_error(code: "unauthorized", message: error.message.presence || "Unauthorized", status: :unauthorized)
  end

  def current_user
    @current_user
  end

  def bearer_token
    request.authorization.to_s.split.last.presence || raise(::Auth::AuthenticationError, "Missing bearer token")
  end
end
