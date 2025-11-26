class Family < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :family_events, dependent: :destroy
  has_many :people, dependent: :destroy
  has_many :folders, dependent: :destroy
  has_many :documents, dependent: :destroy

  def total_storage_used
    documents.sum(:file_size) || 0
  end

  def storage_display
    bytes = total_storage_used
    if bytes >= 1_073_741_824
      "#{(bytes / 1_073_741_824.0).round(1)} Go"
    elsif bytes >= 1_048_576
      "#{(bytes / 1_048_576.0).round(1)} Mo"
    elsif bytes >= 1024
      "#{(bytes / 1024.0).round(1)} Ko"
    else
      "#{bytes} o"
    end
  end
end
