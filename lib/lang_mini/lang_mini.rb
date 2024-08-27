module LangMini
  def self.reset
    @@logger = nil
  end

  def self.logger=(p_logger)
    @@logger = p_logger
  end

  def self.logger
    @@logger ||= Logger.new($stdout)
  end
end

module LangMini::Tools
end

require_relative "lib/assistant"
require_relative "lib/client"
require_relative "lib/completion"
require_relative "lib/config"
require_relative "lib/conversation"
require_relative "lib/logger"
require_relative "lib/message"
require_relative "lib/tool"
require_relative "lib/utils"
require_relative "lib/tools/database"
require_relative "lib/tools/math"
