class Task < ApplicationRecord
  validates :title,  presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 1000 }

  scope :deadline, -> { order(deadline: "ASC") }
  scope :created_at, -> { order(created_at: "DESC") }
  scope :priority, ->(priority) { where(priority: priority) }
  scope :ambiguous, ->(ambiguous) { where("title LIKE ?", "%#{ambiguous}%") }
end
