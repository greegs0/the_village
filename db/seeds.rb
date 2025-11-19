# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

Task.destroy_all

pediatre = Task.create!(
  name: "Rv Pédiatre",
  status: false,
  created_date: Date.new(2025, 11, 19),
  target_date: Date.new(2025, 12, 5),
  description: "Rendez-vous de contrôle",
  time: "09:30"
)

electricien = Task.create!(
  name: "Facture électricien",
  status: false,
  created_date: Date.new(2025, 11, 5),
  target_date: Date.new(2025, 11, 25),
  description: "Payer la facture travaux",
  time: ""
)

banque = Task.create!(
  name: "Rv Banque",
  status: true,
  created_date: Date.new(2025, 11, 7),
  target_date: Date.new(2025, 11, 25),
  description: "Discussion prêt / épargne",
  time: "11:00"
)

sport = Task.create!(
  name: "Muscu",
  status: true,
  created_date: Date.new(2025, 11, 9),
  target_date: Date.new(2025, 11, 25),
  description: "Séance épaules / dos",
  time: "18:00"
)

yoga = Task.create!(
  name: "Yoga",
  status: true,
  created_date: Date.new(2025, 11, 8),
  target_date: Date.new(2025, 11, 25),
  description: "Séance détente",
  time: "08:00"
)

courses = Task.create!(
  name: "Passer chez Leclerc",
  status: false,
  created_date: Date.new(2025, 11, 1),
  target_date: Date.new(2025, 11, 25),
  description: "Courses de la semaine",
  time: ""
)

cinema = Task.create!(
  name: "MK2 avec Loulou",
  status: false,
  created_date: Date.new(2025, 11, 3),
  target_date: Date.new(2025, 11, 25),
  description: "Film du soir",
  time: "20:30"
)

kine = Task.create!(
  name: "Séance de kiné",
  status: true,
  created_date: Date.new(2025, 11, 4),
  target_date: Date.new(2025, 11, 25),
  description: "Rééducation",
  time: "14:00"
)

escalade = Task.create!(
  name: "Escalade",
  status: true,
  created_date: Date.new(2025, 11, 5),
  target_date: Date.new(2025, 11, 25),
  description: "Bloc",
  time: "19:00"
)

facture = Task.create!(
  name: "Admin :(",
  status: true,
  created_date: Date.new(2025, 11, 6),
  target_date: Date.new(2025, 11, 25),
  description: "Petite paperasse",
  time: ""
)

placard = Task.create!(
  name: "Ranger placards cuisine :(",
  status: false,
  created_date: Date.new(2025, 11, 18),
  target_date: Date.new(2025, 11, 25),
  description: "Tri + rangement",
  time: ""
)

poker = Task.create!(
  name: "Soirée Poker $$$",
  status: false,
  created_date: Date.new(2025, 11, 12),
  target_date: Date.new(2025, 11, 25),
  description: "Soirée entre amis",
  time: "21:00"
)
