class Task < ApplicationRecord
  belongs_to :user
  belongs_to :assignee, class_name: "User"
  has_many :users, dependent: :destroy
  validates :name, presence: true
  validates :user, presence: true
  validates :target_date, presence: true
end
