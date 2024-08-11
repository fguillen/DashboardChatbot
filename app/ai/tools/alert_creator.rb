class Tools::AlertCreator < AI::Tool
  def initialize(front_user:)
    @front_user = front_user
  end

  def tool_description_path
    "#{__dir__}/alert_creator.json"
  end

  def create_alert(name:, schedule:, context:, prompt:)
    puts ">>>> Alert creating with: name: #{name}, schedule: #{schedule}, context: #{context}, prompt: #{prompt}"
    Alert.create!(
      name:,
      schedule:,
      context:,
      prompt:,
      front_user: @front_user
    )
  end
end
