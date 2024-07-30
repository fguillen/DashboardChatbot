module AI
  class Client
    attr_reader :client

    def initialize(access_token:)
      @client = OpenRouter::Client.new(access_token: access_token)
    end

    def models
      @models ||= @client.models.map { |e| e["id"] }.sort
    end
  end
end
