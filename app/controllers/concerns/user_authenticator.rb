require 'active_support/concern'
require 'jwt'

module UserAuthenticator
  extend ActiveSupport::Concern

  include JwtAuthenticator

  SECRET_KEY_BASE = "USER_#{Rails.application.credentials.secret_key_base}"

  # encode
  def encode(user_id, token_expired_at)
    jwt_encode(user_id, token_expired_at, SECRET_KEY_BASE)
  end

  # decode
  def decode(encoded_token)
    jwt_decode(encoded_token, SECRET_KEY_BASE)
  end

  private

  # authenticate
  def authenticate
    authenticate_token || render_unauthorized(CONSTANTS::ERR_UNAUTHORIZED)
  end

  # Authenticate token
  def authenticate_token
    Rails.logger.info "authenticate_token"
    authenticate_with_http_token do |token, _options|
      begin
        payload = decode(token)
        @current_user = MUser.find_by(id: payload['user_id'])
      rescue JWT::VerificationError
        return false
      rescue JWT::ExpiredSignature
        return false
      rescue StandardError
        return false
      end
      return !@current_user.blank?
    end
  end

  
end
