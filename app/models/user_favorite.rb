class UserFavorite < ApplicationRecord
  log_book
  strip_attributes

  self.primary_key = :uuid
  include HasUuid

  has_neighbors :prompt_embedding

  belongs_to :user_reaction
  has_one :front_user, through: :user_reaction

  validates :user_reaction, presence: true, uniqueness: true

  scope :order_by_recent, -> { order("created_at desc") }
end
