class ApplicationController < ActionController::API
  include Pundit::Authorization

  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
  rescue_from ActiveRecord::RecordInvalid, with: :render_record_invalid
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from Pundit::NotAuthorizedError, with: :render_forbidden

  private

  def render_error(code:, message:, status:, details: nil)
    payload = {
      error: {
        code: code,
        message: message
      }
    }

    payload[:error][:details] = details if details.present?

    render json: payload, status: status
  end

  def render_record_invalid(exception)
    render_error(
      code: "validation_error",
      message: exception.record.errors.full_messages.to_sentence,
      status: :unprocessable_entity,
      details: exception.record.errors.to_hash
    )
  end

  def render_parameter_missing(exception)
    render_error(code: "bad_request", message: exception.message, status: :bad_request)
  end

  def render_not_found(_exception)
    render_error(code: "not_found", message: "Resource not found", status: :not_found)
  end

  def render_forbidden(_exception)
    render_error(code: "forbidden", message: "You are not allowed to perform this action", status: :forbidden)
  end
end
