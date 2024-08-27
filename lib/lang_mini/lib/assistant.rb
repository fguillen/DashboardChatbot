class LangMini::Assistant
  attr_reader :conversation
  attr_reader :model

  def initialize(
    client:,
    model: "openrouter/auto",
    conversation: nil,
    on_new_message: nil
  )
    @client = client
    @system_directive = system_directive
    @model = model
    @conversation = conversation || LangMini::Conversation.new
    @on_new_message = on_new_message

    after_initialize
  end

  def completion(message:, model: @model)
    init_system_directive

    add_new_message(message)

    complete

    @conversation.new_messages
  end

  def system_directive
    nil
  end

  def tools
    nil
  end

  def after_initialize
  end

  private

  # From: https://github.com/patterns-ai-core/langchainrb/blob/ff699356068bd7d6bc768e5518f6b4fdcbdfc90f/lib/langchain/assistants/assistant.rb#L275
  def run_tools(tool_calls)
    # Iterate over each function invocation and submit tool output
    tool_calls.each do |tool_call|
      run_tool(tool_call)
    end

    complete
  end

  def run_tool(tool_call)
    tool_call_id, tool_name, method_name, tool_arguments = extract_tool_call_args(tool_call)

    log("run_tool: tool_call_id: #{tool_call_id}, tool_name: #{tool_name}, method_name: #{method_name}, tool_arguments: #{tool_arguments}")

    output = nil
    begin
      tool_instance =
        tools.find do |t|
          t.class_name_sanitized == tool_name
        end or raise ArgumentError, "Tool not found in assistant.tools '#{tool_name}'"

      output = tool_instance.send(method_name, **tool_arguments)
    rescue => e
      log("Error running tool #{tool_name} with arguments #{tool_arguments}:")
      log(e.message)
      log(e.backtrace.join("\n"))
      output = e.message
    end

    log("run_tool: output: #{output}")

    submit_tool_output(tool_call_id: tool_call_id, name: tool_call[:function][:name], output: output)
  end

  def complete
    response =
      @client.complete(
        @conversation.messages_data,
        model: @model,
        extras: {
          tools: extract_tools,
          temperature: 0
        }
      )

    completion = LangMini::Completion.new(response)
    message = LangMini::Message.from_completion(completion)
    add_new_message(message)

    if(completion.tools?)
      run_tools(completion.message[:tool_calls])
    end
  end

  def init_system_directive
    return if system_directive.blank?
    return if @conversation.messages.filter do |m|
      m.role == "system" && m.content == system_directive.strip
    end.present?

    message = LangMini::Message.from_hash({ role: "system", content: system_directive })
    add_new_message(message)
  end

  def extract_tools
    return [] if tools.nil?

    tools.map do |tool|
      tool.tool_description
    end.flatten
  end




  # // Some models might include their reasoning in content
  # "message": {
  #   "role": "assistant",
  #   "content": null,
  #   "tool_calls": [
  #     {
  #       "id": "call_9pw1qnYScqvGrCH58HWCvFH6",
  #       "type": "function",
  #       "function": {
  #         "name": "get_current_weather",
  #         "arguments": "{ \"location\": \"Boston, MA\"}"
  #       }
  #     }
  #   ]
  # },
  # From: https://github.com/patterns-ai-core/langchainrb/blob/ff699356068bd7d6bc768e5518f6b4fdcbdfc90f/lib/langchain/assistants/assistant.rb#L365C1-L379C14
  def extract_tool_call_args(tool_call)
    tool_call_id = tool_call.dig(:id)

    function_name = tool_call.dig(:function, :name)
    tool_name, method_name = function_name.split("__")

    tool_arguments = tool_call.dig(:function, :arguments)
    tool_arguments = JSON.parse(tool_arguments, symbolize_names: true)

    result = [tool_call_id, tool_name, method_name, tool_arguments]
    result
  end

  # {
  #   "role": "tool",
  #   "name": "get_current_weather",
  #   "tool_call_id": "call_9pw1qnYScqvGrCH58HWCvFH6",
  #   "content": "{\"temperature\": \"22\", \"unit\": \"celsius\", \"description\": \"Sunny\"}"
  # }
  def submit_tool_output(tool_call_id:, name:, output:)
    message = LangMini::Message.from_hash({ role: "tool", tool_call_id:, name:, content: output.to_s })
    add_new_message(message)
  end

  def add_new_message(message)
    @conversation.add_message(message)
    if @on_new_message
      @on_new_message.call(message)
    end
  end

  def log(message)
    LangMini.logger.debug("LangMini::Assistant: #{message}")
  end
end
