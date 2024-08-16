require_relative "#{Rails.root}/lib/ai/client"
AI_CLIENT = AI::Client.new(access_token: APP_CONFIG["open_router_key"])
