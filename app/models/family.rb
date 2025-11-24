class Family < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :family_events, dependent: :destroy
  has_many :people, dependent: :destroy
  # has_many :files, dependent: :destroy
end
