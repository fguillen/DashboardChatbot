class AlertExecuterJob < ApplicationJob
  def perform(alert)
    alert.perform
  end
end
