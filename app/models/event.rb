class Event < ApplicationRecord
  belongs_to :user
  has_many :event_registrations, dependent: :destroy
  has_many :participants, through: :event_registrations, source: :user

  validates :name, presence: true, length: { minimum: 3, maximum: 255 }
  validates :date, presence: true
  validates :max_participations, presence: true, numericality: { greater_than: 0 }
  validates :place, presence: true

  # Scope pour récupérer les événements avec des coordonnées
  scope :with_coordinates, -> { where.not(latitude: nil, longitude: nil) }

  # Vérifie si l'événement a des coordonnées valides
  def has_coordinates?
    latitude.present? && longitude.present?
  end

  # Vérifie si un utilisateur est inscrit à cet événement
  def registered?(user)
    return false unless user
    event_registrations.exists?(user_id: user.id)
  end

  # Nombre de places restantes
  def spots_left
    max_participations - participants.count
  end

  # Vérifie si l'événement est complet
  def full?
    participants.count >= max_participations
  end
end
