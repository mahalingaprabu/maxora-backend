# lib/json_web_token.rb
class JsonWebToken
  SECRET_KEY = ENV['JWT_SECRET'].presence || Rails.application.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end

  def self.decode(token)
    return nil unless token
    body = JWT.decode(token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new(body)
  rescue JWT::ExpiredSignature, JWT::DecodeError => e
    Rails.logger.info("[JWT decode error] #{e.message}")
    nil
  end
end
