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
user: lois,
assignee: al
)
