class AI::Conversation
  attr_reader :messages
  attr_reader :new_messages

  def initialize
    @messages = []
    @new_messages = []
  end

  def add_message(message)
    @messages << message
    @new_messages << message
  end

  def messages_data
    @messages.map(&:data)
  end

  def reset_new_messages
    @new_messages = []
  end
end
