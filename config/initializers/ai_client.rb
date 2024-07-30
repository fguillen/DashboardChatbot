require_relative "#{Rails.root}/lib/ai/client"
AI_CLIENT = AI::Client.new(access_token: ENV["OPEN_ROUTER_KEY"])
