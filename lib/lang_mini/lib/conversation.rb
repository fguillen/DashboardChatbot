class LangMini::Conversation
  attr_accessor :messages
  attr_reader :new_messages

  def initialize
    @messages = []
    @new_messages = []
  end

  def add_message(message)
    @messages << message
    @new_messages << message
  end

  # TODO: investigate why I see message.raw attribute here
  def messages_data
    @messages.map(&:data)
  end

  def reset_new_messages
    @new_messages = []
  end
end
