class AI::Conversation
  attr_reader :messages

  def initialize
    @messages = []
  end

  def add_message(message)
    @messages << message
  end

  def messages_data
    @messages.map(&:data)
  end
end
