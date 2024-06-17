class Api::ApiController < ApplicationController
  before_action :authenticate_via_token

  def supported_tokens
    Array.wrap(APP_CONFIG["api"]["token"])
  end

  private

  def authenticate_via_token
    if request.headers["Authorization"].to_s.start_with?("DashboardChatbot ")
      token = request.headers["Authorization"]["DashboardChatbot ".length..].to_s.strip
      return if token.present? && supported_tokens.include?(token)
    end

    head :unauthorized
  end
end
