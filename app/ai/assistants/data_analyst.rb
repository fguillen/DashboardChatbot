class Assistants::DataAnalyst < AI::Assistant
  def system_directive
    File.read("#{Rails.root}/config/assistant_instructions.md")
  end
end
