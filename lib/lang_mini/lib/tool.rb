class LangMini::Tool
  # Tool description like in here: https://openrouter.ai/docs/requests#tool-calls
  def tool_description_path
  end

  def tool_description
    description = JSON.parse(File.read(tool_description_path), symbolize_names: true)

    # Append the tool class name to the function name
    description.each do |function_description|
      function_description[:function][:name] = "#{class_name_sanitized}__#{function_description[:function][:name]}"
    end

    description
  end

  def class_name_sanitized
    self.class.name.gsub("::", "-")
  end
end
