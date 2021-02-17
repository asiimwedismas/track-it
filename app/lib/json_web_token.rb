class JsonWebToken
  JWT_PRIVATE_KEY = Rails.application.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, JWT_PRIVATE_KEY)
  end

  def self.decode(token)
    # get payload; first index in decoded Array
    body = JWT.decode(token, JWT_PRIVATE_KEY)[0]
    HashWithIndifferentAccess.new body
  rescue JWT::DecodeError => e
    raise ExceptionHandler::InvalidToken, e.message
  end
end
