class CronTasks::LoadAllAlertsService < Service
  def perform
    Alert.all.each do |alert|
      alert.set_cron_job
    end
  end
end
