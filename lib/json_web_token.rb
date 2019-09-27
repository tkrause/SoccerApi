class JsonWebToken
  class << self
    def encode(payload, exp = 7.days.from_now)
      payload[:exp] = exp.to_i

      expires_in = (7.days.from_now - Time.now).to_i
      {expires_in: expires_in, token: JWT.encode(payload, Rails.application.secrets.secret_key_base)}
    end

    def decode(token)
      body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end