require "test_helper"

class Assistants::DataAnalystTest < Minitest::Test
  def test_tools_calls
    assistant = Assistants::DataAnalyst.new(model: "openai/gpt-4o-mini-2024-07-18")

    # new_messages = assistant.completion({ role: "user", content: "what tools you have?" })
    # puts ">>>> last message"
    # puts JSON.pretty_generate(new_messages.last.to_s)

    new_messages = assistant.completion(
      {
        role: "user",
        content: "sum the numbers 2 and 3. use the tools: Tools-Math__sum"
      }
    )
    puts ">>>> last message"
    puts JSON.pretty_generate(new_messages.last.to_s)
  end

  def test_tool_database
    assistant = Assistants::DataAnalyst.new(model: "openai/gpt-4o-mini-2024-07-18")
    new_messages = assistant.completion(
      {
        role: "user",
        content: "Tell me the number of clients we have in our database"
      }
    )
    puts ">>>> last message"
    puts JSON.pretty_generate(new_messages.last.to_s)
  end

  # def test_run_tools
  #   tool_calls =  [
  #     {
  #       "id" => "call_cEgXXzO4qgbMN56oR0OzH6YL",
  #       "type" => "function",
  #       "function" => {
  #         "name" => "Tools-Math__sum",
  #         "arguments" => "{\"num_1\":2,\"num_2\":3}"
  #       }
  #     }
  #   ]


  #   ai_conversation = AI::Conversation.new
  #   new_messages = AI::Message.from_hash({ role: "user", content: "sum the numbers 2 and 3" })
  #   ai_conversation.add_message(new_messages)
  #   assistant = Assistants::DataAnalyst.new(ai_conversation: ai_conversation)

  #   assistant.run_tools(tool_calls)
  # end
end
