class Tools::Math < AI::Tool
  def tool_description_path
    "#{__dir__}/math.json"
  end

  def sum(num_1:, num_2:)
    num_1 + num_2
  end
end
