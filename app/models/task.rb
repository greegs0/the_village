class Task < ApplicationRecord
  has_many :users, dependent: :destroy
  validates :name, presence: true
  validates :user, presence: true
  validates :target_date, presence: true
end


