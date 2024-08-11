class AlertExecuterJob < ApplicationJob
  def perform(alert)
    alert.process
  end
end
