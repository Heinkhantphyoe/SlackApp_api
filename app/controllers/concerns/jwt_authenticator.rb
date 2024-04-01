require 'active_support/concern'
require 'jwt'

module JwtAuthenticator
  extend ActiveSupport::Concern

  # jwt_encode
  def jwt_encode(user_id, token_expired_at, secret_key_base)
    preload = { user_id:, exp: token_expired_at.to_i }
    JWT.encode(preload, secret_key_base, 'HS256')
  end

  # jwt_decode
  def jwt_decode(encoded_token, secret_key_base)
    decoded_dwt = JWT.decode(encoded_token, secret_key_base, true, algorithm: 'HS256')
    decoded_dwt.first
  end
end
