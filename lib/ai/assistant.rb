class AI::Assistant
  attr_reader :model

  def initialize(model: "openrouter/auto", ai_conversation: nil)
    @client = client || AI::Client.new(access_token: ENV["OPEN_ROUTER_KEY"])
    @system_directive = system_directive
    @model = model
    @conversation = ai_conversation
    init_conversation
  end

  def completion(hash, model: nil)
    ai_message = AI::Message.from_hash(hash)
    @conversation.add_message(ai_message)

    puts ">>>> @conversation: #{@conversation.class.name}"
    puts ">>>> @conversation.messages: #{@conversation.messages.map { |e| e.class.name }}"
    puts ">>>> @conversation.messages_data: #{@conversation.messages_data}"

    response =
      @client.complete(
        @conversation.messages_data,
        model: model || @model
      )

    completion = AI::Completion.new(response)
    message = AI::Message.from_completion(completion)
    @conversation.add_message(message)

    @conversation.new_messages
  end

  def system_directive
    nil
  end

  def client
    @client
  end

  private

  def init_conversation
    return if @conversation.messages.present? or @system_directive.blank?

    if system_directive.present?
      message = AI::Message.from_hash({ role: "system", content: system_directive })
      @conversation.add_message(message)
    end
  end
end
