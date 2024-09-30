module HasApiToken
  extend ActiveSupport::Concern

  included do
    before_validation :initialize_api_token, on: :create

    def initialize_api_token
      self.api_token ||= ShortUUID.shorten(SecureRandom.uuid)
    end
  end
end
