class AlertEmail < ApplicationRecord
  self.primary_key = :uuid
  include HasUuid

  belongs_to :alert

  scope :order_by_recent, -> { order("alert_emails.created_at desc") }
end
