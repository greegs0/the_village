class Task < ApplicationRecord
  belongs_to :family
  belongs_to :user
  belongs_to :assignee, class_name: "Person"

  validates :name, presence: true
  validates :user, presence: true
  validates :target_date, presence: true

  # Set default value for status (false = incomplete)
  after_initialize :set_default_status, if: :new_record?

  private

  def set_default_status
    self.status ||= false
  end
end
