class Person < ApplicationRecord
  belongs_to :family

  validates :name, presence: true

  # Calcule l'âge à partir de la date de naissance
  def age
    return nil unless birthday

    today = Date.today
    age = today.year - birthday.year
    age -= 1 if today < birthday + age.years
    age
  end
end
