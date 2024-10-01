class Api::Front::ApiController < ApplicationController
  include Api::Concerns::CaptureErrors
  include Api::Concerns::AuthenticateViaApiToken

  protect_from_forgery with: :null_session

  before_action :load_current_user

  def load_current_user
    @current_front_user = FrontUser.find_by!(api_token: @api_token)
  end

  def current_front_user
    @current_front_user
  end
end
