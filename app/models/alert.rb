class Alert < ApplicationRecord
  self.primary_key = :uuid
  include HasUuid

  belongs_to :front_user
  has_many :alert_emails, dependent: :destroy
  has_one :conversation, dependent: :destroy

  scope :order_by_recent, -> { order("alerts.created_at desc") }

  before_create :set_default_model
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

  def process
    puts ">>>> Alert.perform: #{name}"
    Alerts::AlertProcessor.perform(self)
  end

  def set_default_model
    self.model ||= "openai/gpt-4o"
  end

  def last_time_sent_at
    alert_emails.order_by_recent.first&.created_at
  end

  def schedule_to_human
    Cronex::ExpressionDescriptor.new(schedule).description
  end
end
