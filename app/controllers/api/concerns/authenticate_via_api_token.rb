module Api::Concerns::AuthenticateViaApiToken
  extend ActiveSupport::Concern

  class AuthorizationError < StandardError; end

  included do
    before_action :validate_api_token
  end

  def validate_api_token
    authorization_header_elements = request.headers["Authorization"]&.split

    raise AuthorizationError.new("Missing Authorization header") if authorization_header_elements.blank?
    raise AuthorizationError.new("Invalid Authorization header") if authorization_header_elements.size != 2
    raise AuthorizationError.new("Invalid Authorization header") if authorization_header_elements.first != "Bearer"

    @api_token = authorization_header_elements.second
  end
end
