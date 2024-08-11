require "test_helper"

class Alerts::AlertProcessorTest < ActiveSupport::TestCase
  def test_perform
    alert = FactoryBot.create(:alert, prompt: "How many clients with sales I have had in 2024?")

    Alerts::AlertProcessor.perform(alert)
  end
end
