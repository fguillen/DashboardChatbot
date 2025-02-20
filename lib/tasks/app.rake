namespace :dashboardchatbot do
  namespace :utils do
    desc "Renaming project to a new name"
    task :renaming_project, [:new_project_name] => :environment do |_t, args|
      RenamingProject.perform(args.new_project_name)
    end

    desc "Send test email"
    task send_test_email: :environment do
      Notifier.simple_test_email("Wadus", "fguillen.mail@gmail.com").deliver_now
    end
  end

  desc "This is a task for testing"
  task test: :environment do
    Rails.logger.info("[#{Time.now}] This is the test task")
  end

  desc "Load all the CSV data into the database"
  task load_csvs: :environment do
    Data::LoadAllCsvsService.perform(force: true)
  end

  desc "Load all Alerts and create cron jobs"
  task load_alerts: :environment do
    CronTasks::LoadAllAlertsService.perform
  end
end
