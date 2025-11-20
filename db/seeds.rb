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
Event.destroy_all

puts "créating 2 users"
georges = User.create!(email: "georges@gmail.com", password: "azerty", status: "member", name: "Fabien Maheu")
fabien = User.create!(email: "fabien@gmail.com", password: "azerty", status: "member", name: "Georges Maheu")

puts "créating 3 events"
Event.create!(name: "piscine", date: Date.today + 1, description: "avec les enfants", place: "L'espadon", user: georges)
Event.create!(name: "Patinoire", date: Date.today + 2, description: "aussi avec les anfants", place: "Le glaçon", user: georges)
Event.create!(name: "cinema", date: Date.today + 4, description: "Batman", place: "le magnifique", user: fabien)
