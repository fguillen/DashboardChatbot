class AI::Tool
  def tool_description_path
  end

  def tool_description
    JSON.parse(File.read(tool_description_path))
  end
end
