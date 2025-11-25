class Folder < ApplicationRecord
  belongs_to :family
  has_many :documents, dependent: :destroy

  validates :name, presence: true

  # Default icons for common folder types
  ICONS = {
    'medical' => '📄',
    'school' => '📚',
    'admin' => '📋',
    'insurance' => '🛡️',
    'bills' => '💰',
    'contracts' => '📝',
    'default' => '📁'
  }.freeze

  def icon_display
    icon.presence || ICONS['default']
  end

  def documents_count
    documents.count
  end
end
