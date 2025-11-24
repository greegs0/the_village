class FamilyEvent < ApplicationRecord
  belongs_to :family

  # Validations
  validates :title, presence: true
  validates :event_type, presence: true
  validates :start_date, presence: true

  # Event types
  EVENT_TYPES = {
    'anniversaire' => { name: 'Anniversaire', icon: '🎂', badge_class: 'bg-pink', color: '#f6339a' },
    'garde' => { name: 'Garde d\'enfant', icon: '👶', badge_class: 'bg-primary', color: '#2b7fff' },
    'medical' => { name: 'Rendez-vous médical', icon: '🦷', badge_class: 'bg-secondary', color: '#c6005b' },
    'scolaire' => { name: 'Événement scolaire', icon: '🏫', badge_class: 'bg-success', color: '#00c950' },
    'vacances' => { name: 'Vacances', icon: '✈️', badge_class: 'bg-info', color: '#1347e5' },
    'indisponibilite' => { name: 'Indisponibilité', icon: '🚫', badge_class: 'bg-danger', color: '#ef4444' },
    'autre' => { name: 'Autre', icon: '📌', badge_class: 'bg-secondary', color: '#6a7282' }
  }.freeze

  # Callbacks
  before_save :set_event_metadata
  before_validation :set_title_for_unavailability

  # Scope pour récupérer les événements d'un mois donné
  # Inclut les événements qui commencent, se terminent ou se déroulent pendant le mois
  scope :for_month, ->(date) {
    month_start = date.beginning_of_month
    month_end = date.end_of_month
    where('(start_date <= ? AND (end_date IS NULL OR end_date >= ?)) OR (start_date >= ? AND start_date <= ?)',
          month_end, month_start, month_start, month_end)
  }

  # Méthode pour obtenir le nom du type d'événement
  def type_name
    EVENT_TYPES.dig(event_type, :name) || 'Autre'
  end

  # Méthode pour obtenir la couleur hexadécimale du type d'événement
  def event_color
    EVENT_TYPES.dig(event_type, :color) || '#6a7282'
  end

  # Méthode pour formater la date
  def formatted_date
    if end_date && end_date != start_date
      "#{start_date.strftime('%d %B %Y')} → #{end_date.strftime('%d %B %Y')}"
    else
      start_date.strftime('%d %B %Y')
    end
  end

  # Méthode pour formater l'heure
  def formatted_time
    if time
      time.strftime('%H:%M')
    else
      'Toute la journée'
    end
  end

  private

  # Définir automatiquement l'icône et la classe du badge en fonction du type
  def set_event_metadata
    if event_type.present? && EVENT_TYPES[event_type]
      self.event_icon = EVENT_TYPES[event_type][:icon]
      self.badge_class = EVENT_TYPES[event_type][:badge_class]
    end
  end

  # Générer automatiquement le titre pour les indisponibilités
  def set_title_for_unavailability
    if event_type == 'indisponibilite' && assigned_to.present?
      self.title = "#{assigned_to} Indisponible"
    end
  end
end
