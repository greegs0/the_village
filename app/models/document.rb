class Document < ApplicationRecord
  belongs_to :folder
  belongs_to :family
  belongs_to :user

  has_one_attached :file

  validates :name, presence: true
  validate :acceptable_file

  ALLOWED_CONTENT_TYPES = %w[
    application/pdf
    image/jpeg
    image/png
    image/gif
    application/msword
    application/vnd.openxmlformats-officedocument.wordprocessingml.document
    application/vnd.ms-excel
    application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
  ].freeze

  MAX_FILE_SIZE = 10.megabytes

  private

  def acceptable_file
    return unless file.attached?

    unless file.blob.byte_size <= MAX_FILE_SIZE
      errors.add(:file, "est trop volumineux (max #{MAX_FILE_SIZE / 1.megabyte} Mo)")
    end

    unless ALLOWED_CONTENT_TYPES.include?(file.blob.content_type)
      errors.add(:file, "doit être un PDF, une image (JPG, PNG, GIF) ou un document Office")
    end
  end

  public

  scope :recent, -> { order(created_at: :desc) }
  scope :favorites, -> { where(is_favorite: true) }

  # File type icons
  FILE_ICONS = {
    'pdf' => '📄',
    'doc' => '📝',
    'docx' => '📝',
    'xls' => '📊',
    'xlsx' => '📊',
    'jpg' => '🖼️',
    'jpeg' => '🖼️',
    'png' => '🖼️',
    'gif' => '🖼️',
    'default' => '📎'
  }.freeze

  def icon_display
    FILE_ICONS[file_type&.downcase] || FILE_ICONS['default']
  end

  def file_size_display
    return 'N/A' unless file_size

    if file_size >= 1_048_576
      "#{(file_size / 1_048_576.0).round(1)} MB"
    elsif file_size >= 1024
      "#{(file_size / 1024.0).round(1)} KB"
    else
      "#{file_size} B"
    end
  end

  def time_ago_display
    time_diff = Time.current - created_at

    if time_diff < 1.hour
      "Il y a #{(time_diff / 60).to_i} min"
    elsif time_diff < 24.hours
      "Il y a #{(time_diff / 3600).to_i}h"
    elsif time_diff < 7.days
      "Il y a #{(time_diff / 86400).to_i} jour#{'s' if time_diff >= 2.days}"
    elsif time_diff < 30.days
      "Il y a #{(time_diff / 604800).to_i} sem"
    else
      created_at.strftime('%d/%m/%Y')
    end
  end

  def uploader_initial
    user&.name&.first&.upcase || '?'
  end

  def uploader_name
    user&.name || 'Inconnu'
  end

  def toggle_favorite!
    update(is_favorite: !is_favorite)
  end
end
