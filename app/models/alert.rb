class Alert < ApplicationRecord
  self.primary_key = :uuid
  include HasUuid

  after_commit :set_cron_job, on: [:create, :update]
  after_commit :remove_cron_job, on: :destroy

  def set_cron_job
    Sidekiq::Cron::Job.create(
      name: "Alert-#{self.id}",
      cron: self.schedule,
      class: "AlertExecuterJob", args: self
    )
  end

  def remove_cron_job
    Sidekiq::Cron::Job.destroy("Alert-#{self.id}")
  end
end
