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
Event.destroy_all

puts "créating 2 users"
georges = User.create!(email: "georges@gmail.com", password: "azerty", status: "member", name: "Fabien Maheu")
fabien = User.create!(email: "fabien@gmail.com", password: "azerty", status: "member", name: "Georges Maheu")

puts "créating 3 events"
Event.create!(name: "piscine", date: Date.today + 1, description: "avec les enfants", place: "L'espadon", user: georges)
Event.create!(name: "Patinoire", date: Date.today + 2, description: "aussi avec les anfants", place: "Le glaçon", user: georges)
Event.create!(name: "cinema", date: Date.today + 4, description: "Batman", place: "le magnifique", user: fabien)
