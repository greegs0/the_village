class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy

  validates :user_id, presence: true

  # Scope pour récupérer les chats d'un user triés par date de mise à jour
  scope :recent, -> { order(updated_at: :desc) }

  # Méthode pour récupérer le dernier message du chat
  def last_message
    messages.order(created_at: :desc).first
  end

  # Méthode helper pour accéder à la famille via l'utilisateur
  def family
    user.family
  end
end
