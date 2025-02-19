require "test_helper"

class Assistants::DataAnalystTest < ActiveSupport::TestCase
  def setup
    LangMini.logger.level = Logger::WARN
  end

  def test_list_of_tools
    front_user = FactoryBot.create(:front_user)
    assistant = Assistants::DataAnalyst.new(front_user:)
    lang_mini_message =
      LangMini::Message.from_hash(
        role: "user",
        content: "what tools you have?"
      )

    # Write request fixtures
    # OpenRouter::Client.any_instance.expects(:complete).with() do |conversation, key_parameters|
    #   write_fixture("ai/data_analyst_list_of_tools_request.json", JSON.pretty_generate(conversation))
    #   puts ">>>> model: #{key_parameters[:model]}"
    #   write_fixture("ai/data_analyst_assistant_extras.json", JSON.pretty_generate(key_parameters[:extras]))
    # end

    # Mock OpenRouter::Client
    OpenRouter::Client.any_instance.expects(:complete).with(
      JSON.parse(read_fixture("ai/data_analyst_list_of_tools_request.json"), symbolize_names: true),
      model: LangMini::DEFAULT_MODEL,
      extras: JSON.parse(read_fixture("ai/data_analyst_assistant_extras.json"), symbolize_names: true)
    ).returns(
      JSON.parse(read_fixture("ai/data_analyst_list_of_tools_completion.json"), symbolize_names: true)
    )

    new_lang_mini_messages = assistant.completion(message: lang_mini_message)
    last_lang_mini_message = new_lang_mini_messages.last

    assert_equal(3, new_lang_mini_messages.count)
    assert_equal("assistant", last_lang_mini_message.role)
    assert(last_lang_mini_message.content.include?("LangMini-Tools-Math"))
    assert(last_lang_mini_message.content.include?("LangMini-Tools-Database"))
    assert(last_lang_mini_message.content.include?("Tools-Chart"))
    assert(last_lang_mini_message.content.include?("Tools-AlertCreator"))
    assert_equal("gen-5Sw0eZpysTZKtUTRkIScI6azTmA2", last_lang_mini_message.completion.data[:id])
  end

  def test_tool_database
    front_user = FactoryBot.create(:front_user)
    assistant = Assistants::DataAnalyst.new(front_user:)
    lang_mini_message =
      LangMini::Message.from_hash(
        role: "user",
        content: "Tell me the number of clients we have in our database"
      )


    # Write request fixtures
    OpenRouter::Client.any_instance.expects(:complete).with() do |conversation, key_parameters|
      write_fixture("ai/data_analyst_num_of_clients_1_request.json", JSON.pretty_generate(conversation))
      puts ">>>> model: #{key_parameters[:model]}"
      write_fixture("ai/data_analyst_assistant_extras.json", JSON.pretty_generate(key_parameters[:extras]))
    end.returns(
      JSON.parse(read_fixture("ai/data_analyst_num_of_clients_2_completion_tool_call.json"), symbolize_names: true)
    )
    OpenRouter::Client.any_instance.expects(:complete).with() do |conversation, key_parameters|
      write_fixture("ai/data_analyst_num_of_clients_3_tool_result.json", JSON.pretty_generate(conversation))
      puts ">>>> model: #{key_parameters[:model]}"
      write_fixture("ai/data_analyst_assistant_extras.json", JSON.pretty_generate(key_parameters[:extras]))
    end.returns(
      JSON.parse(read_fixture("ai/data_analyst_num_of_clients_4_completion_result.json"), symbolize_names: true)
    )

    # # Mock OpenRouter::Client 1: Request number of clients
    # OpenRouter::Client.any_instance.expects(:complete).with(
    #   JSON.parse(read_fixture("ai/data_analyst_num_of_clients_1_request.json"), symbolize_names: true),
    #   model: LangMini::DEFAULT_MODEL,
    #   extras: JSON.parse(read_fixture("ai/data_analyst_assistant_extras.json"), symbolize_names: true)
    # ).returns(
    #   JSON.parse(read_fixture("ai/data_analyst_num_of_clients_2_completion_tool_call.json"), symbolize_names: true)
    # )

    # # Mock OpenRouter::Client 2: Request with the tool result
    # OpenRouter::Client.any_instance.expects(:complete).with(
    #   JSON.parse(read_fixture("ai/data_analyst_num_of_clients_3_tool_result.json"), symbolize_names: true),
    #   model: LangMini::DEFAULT_MODEL,
    #   extras: JSON.parse(read_fixture("ai/data_analyst_assistant_extras.json"), symbolize_names: true)
    # ).returns(
    #   JSON.parse(read_fixture("ai/data_analyst_num_of_clients_4_completion_result.json"), symbolize_names: true)
    # )

    new_lang_mini_messages = assistant.completion(message: lang_mini_message)
    last_lang_mini_message = new_lang_mini_messages.last

    assert_equal(5, new_lang_mini_messages.count)
    assert_equal("assistant", last_lang_mini_message.role)
    assert_equal("We have 68,144 clients in our database.", last_lang_mini_message.content)
    assert_equal("gen-iCy9Y4VTNaNpESbnFUgUdfhrZfqG", last_lang_mini_message.completion.data[:id])
  end

  def test_tool_send_csv
    front_user = FactoryBot.create(:front_user)
    assistant = Assistants::DataAnalyst.new(front_user:)
    lang_mini_message =
      LangMini::Message.from_hash(
        role: "user",
        content: "Send by email the list of clients in our database"
      )

    new_lang_mini_messages = assistant.completion(message: lang_mini_message)
    # last_lang_mini_message = new_lang_mini_messages.last

    puts ">>>>>>>>>>>"
    puts new_lang_mini_messages.map(&:content)
  end

  def test_system_directive_dynamic_fields
    Timecop.freeze("2024-12-01") do
      front_user = FactoryBot.create(:front_user)
      assistant = Assistants::DataAnalyst.new(front_user:)
      assert(assistant.system_directive.include?("current year (2024)"))
      assert(assistant.system_directive.include?("Today is: 2024-12-01"))
    end
  end
end
