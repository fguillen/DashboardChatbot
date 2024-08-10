class AlertExecuterJob < ApplicationJob
  def perform(alert)
    puts ">>>> executing this alert: #{alert.name}"
  end
end
