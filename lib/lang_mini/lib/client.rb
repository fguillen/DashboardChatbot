module LangMini
  class Client
    def initialize(access_token:, request_timeout: 240)
      @open_router_client =
        OpenRouter::Client.new(
          access_token: access_token,
          request_timeout:
        )
    end

    def models
      @models ||=
        Rails.cache.fetch("lang_mini_models", expires_in: 24.hours) do
          @open_router_client.models.map { |e| e["id"] }.sort
        end
    end

    def complete(messages_hash, model:, extras: {})
      log("LangMini::Client.complete")
      log("model: #{model}")
      log("extras:")
      log(JSON.pretty_generate(extras))
      log("messages_hash:")
      log(JSON.pretty_generate(messages_hash))

      response =
        @open_router_client.complete(
          messages_hash,
          model:,
          extras:
        )

      log("Response:")
      log(JSON.pretty_generate(response))

      response
    end

    private

    def log(message)
      ::LangMini.logger.debug("LangMini::Client: #{message}")
    end
  end
end
