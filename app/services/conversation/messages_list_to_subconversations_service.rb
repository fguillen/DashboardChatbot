class Conversation::MessagesListToSubconversationsService < Service
  def perform(conversation)
    result = []

    conversation.messages.in_order.each do |message|
      if(message.role_user?)
        result << [message]
      else
        result << [] if result.empty?
        result.last << message
      end
    end

    result
  end
end
