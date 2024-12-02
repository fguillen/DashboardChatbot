AI_CLIENT =
  LangMini::Client.new(
    access_token: APP_CONFIG["open_router_key"],
    request_timeout: 40 # 40 seconds
  )
