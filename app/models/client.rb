class Client < ApplicationRecord
  log_book
  strip_attributes

  self.primary_key = :uuid
  include HasUuid

  has_many :front_users, dependent: :destroy

  validates :name, presence: true
  validates :db_connection, presence: true
  validates :api_key, presence: true
  validates :default_model, presence: true

  scope :order_by_recent, -> { order("clients.created_at desc") }
end
