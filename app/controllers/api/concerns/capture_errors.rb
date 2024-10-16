module Api::Concerns::CaptureErrors
  extend ActiveSupport::Concern

  included do
    rescue_from StandardError, with: :show_errors
  end

  private

  def show_errors(exception)
    Rails.logger.error(exception)
    Rails.logger.error(exception.backtrace.join("\n"))
    render json: { errors: [exception.message] }, status: :unprocessable_entity
  end
end
