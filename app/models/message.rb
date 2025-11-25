class Message < ApplicationRecord
  belongs_to :chat

  validates :role, presence: true, inclusion: { in: %w[user assistant] }
  validates :content, presence: true

  # Scope pour récupérer les messages dans l'ordre chronologique
  scope :chronological, -> { order(created_at: :asc) }

  # Méthodes helper pour vérifier le rôle
  def from_user?
    role == "user"
  end

  def from_assistant?
    role == "assistant"
  end
end
