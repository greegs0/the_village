class Event < ApplicationRecord
  belongs_to :user

  # Scope pour récupérer les événements avec des coordonnées
  scope :with_coordinates, -> { where.not(latitude: nil, longitude: nil) }

  # Vérifie si l'événement a des coordonnées valides
  def has_coordinates?
    latitude.present? && longitude.present?
  end
end
