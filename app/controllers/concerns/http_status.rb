require 'active_support/concern'

module HttpStatus
  extend ActiveSupport::Concern

  # 400 bad_request
  def render_bad_request
    render json: { errors: [CONSTANTS::ERR_BAD_REQUEST] }, status: :bad_request
  end

  # 401 unauthorized
  def render_unauthorized(exception)
    render json: { errors: [exception] }, status: :unauthorized
  end

  # 500 internal_server_error
  def render_internal_server_error(exception)
    render json: { errors: [exception] }, status: :internal_server_error
  end
end
