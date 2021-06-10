class Task < ApplicationRecord
  validates :name,  presence: true, length: { maximum: 100 }
  validates :content, presence: true, length: { maximum: 1000 }
end
