class Conversation < ApplicationRecord
  log_book
  strip_attributes

  self.primary_key = :uuid
  include HasUuid

  belongs_to :front_user
  has_many :messages, dependent: :destroy

  validates :title, presence: true

  scope :order_by_recent, -> { order("conversations.created_at desc") }
end
