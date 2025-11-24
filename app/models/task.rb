class Task < ApplicationRecord
  belongs_to :family
  belongs_to :user
  belongs_to :assignee, class_name: "Person"

  validates :name, presence: true
  validates :user, presence: true
  validates :target_date, presence: true
end
