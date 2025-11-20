# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.destroy_all
Task.destroy_all

# Création des familles

family1 = Family.create!(name: "Famille Alpha")

# Création des utilisateurs

lois = User.create!(
email: "alice@example.com",
password: "password",
name: "Alice",
status: "member",
family: family1
)

al = User.create!(
email: "bob@example.com",
password: "password",
name: "Bob",
status: "member",
family: family1
)

# Liste des utilisateurs pour assignation aléatoire

users = [lois, al]

# Création des tâches

Task.create!(
name: "Rv Pédiatre",
status: false,
created_date: Date.new(2025, 11, 19),
target_date: Date.new(2025, 12, 5),
description: "Rendez-vous de contrôle",
time: "09:30",
user: users.sample
)

Task.create!(
name: "Facture électricien",
status: false,
created_date: Date.new(2025, 11, 5),
target_date: Date.new(2025, 11, 25),
description: "Payer la facture travaux",
time: "",
user: users.sample
)

Task.create!(
name: "Rv Banque",
status: true,
created_date: Date.new(2025, 11, 7),
target_date: Date.new(2025, 11, 25),
description: "Discussion prêt / épargne",
time: "11:00",
user: users.sample
)

Task.create!(
name: "Muscu",
status: true,
created_date: Date.new(2025, 11, 9),
target_date: Date.new(2025, 11, 25),
description: "Séance épaules / dos",
time: "18:00",
user: users.sample
)

Task.create!(
name: "Yoga",
status: true,
created_date: Date.new(2025, 11, 8),
target_date: Date.new(2025, 11, 25),
description: "Séance détente",
time: "08:00",
user: users.sample
)

Task.create!(
name: "Passer chez Leclerc",
status: false,
created_date: Date.new(2025, 11, 1),
target_date: Date.new(2025, 11, 25),
description: "Courses de la semaine",
time: "",
user: users.sample
)

Task.create!(
name: "MK2 avec Loulou",
status: false,
created_date: Date.new(2025, 11, 3),
target_date: Date.new(2025, 11, 25),
description: "Film du soir",
time: "20:30",
user: users.sample
)

Task.create!(
name: "Séance de kiné",
status: true,
created_date: Date.new(2025, 11, 4),
target_date: Date.new(2025, 11, 25),
description: "Rééducation",
time: "14:00",
user: users.sample
)

Task.create!(
name: "Escalade",
status: true,
created_date: Date.new(2025, 11, 5),
target_date: Date.new(2025, 11, 25),
description: "Bloc",
time: "19:00",
user: users.sample
)

Task.create!(
name: "Admin :(",
status: true,
created_date: Date.new(2025, 11, 6),
target_date: Date.new(2025, 11, 25),
description: "Petite paperasse",
time: "",
user: users.sample
)

Task.create!(
name: "Ranger placards cuisine :(",
status: false,
created_date: Date.new(2025, 11, 18),
target_date: Date.new(2025, 11, 25),
description: "Tri + rangement",
time: "",
user: users.sample
)

Task.create!(
name: "Soirée Poker $$$",
status: false,
created_date: Date.new(2025, 11, 12),
target_date: Date.new(2025, 11, 25),
description: "Soirée entre amis",
time: "21:00",
user: users.sample
)
