# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Nettoyage de la base de données..."
Task.destroy_all
Person.destroy_all
Event.destroy_all
User.destroy_all
Family.destroy_all

puts "👨‍👩‍👧‍👦 Création de la famille..."
family = Family.create!(name: "Famille Maheu")

puts "👤 Création des utilisateurs..."
lois = User.create!(
  email: "lois@example.com",
  password: "password",
  name: "Lois",
  status: "member",
  family: family
)

puts "👥 Création des membres de la famille (People)..."
lois_person = Person.create!(name: "Lois", birthday: Date.new(1985, 5, 15), family: family)
hal = Person.create!(name: "Hal", birthday: Date.new(1983, 3, 20), family: family)
malcolm = Person.create!(name: "Malcolm", birthday: Date.new(2010, 6, 10), family: family)
reese = Person.create!(name: "Reese", birthday: Date.new(2008, 2, 14), family: family)
dewey = Person.create!(name: "Dewey", birthday: Date.new(2012, 9, 25), family: family)

all_people = [lois_person, hal, malcolm, reese, dewey]
other_people = [hal, malcolm, reese, dewey]

puts "📋 Création de 50 tâches réalistes..."

# Liste de tâches de la vie quotidienne
task_templates = [
  { name: "Faire les courses", description: "Supermarché hebdomadaire" },
  { name: "Préparer le dîner", description: "Cuisiner le repas du soir" },
  { name: "Sortir les poubelles", description: "Poubelles jaunes et vertes" },
  { name: "Passer l'aspirateur", description: "Salon et chambres" },
  { name: "Faire la vaisselle", description: "Après le dîner" },
  { name: "Laver le linge", description: "Machine à laver" },
  { name: "Étendre le linge", description: "Mettre à sécher" },
  { name: "Plier le linge", description: "Ranger dans les armoires" },
  { name: "Ranger la chambre", description: "Nettoyer et organiser" },
  { name: "Nettoyer la salle de bain", description: "Lavabo, douche, toilettes" },
  { name: "Arroser les plantes", description: "Intérieur et extérieur" },
  { name: "Promener le chien", description: "Tour du quartier" },
  { name: "Nourrir le chat", description: "Matin et soir" },
  { name: "Faire les devoirs", description: "Mathématiques et français" },
  { name: "Réviser pour l'examen", description: "Histoire-géographie" },
  { name: "Préparer le petit-déjeuner", description: "Pour toute la famille" },
  { name: "Nettoyer la cuisine", description: "Plans de travail et évier" },
  { name: "Tondre la pelouse", description: "Jardin devant et derrière" },
  { name: "Laver la voiture", description: "Intérieur et extérieur" },
  { name: "Faire le lit", description: "Chambre parentale" },
  { name: "Changer les draps", description: "Toutes les chambres" },
  { name: "Acheter du pain", description: "Boulangerie du coin" },
  { name: "Aller à la pharmacie", description: "Chercher ordonnance" },
  { name: "Payer les factures", description: "Électricité et eau" },
  { name: "Rendez-vous dentiste", description: "Contrôle annuel" },
  { name: "Rendez-vous médecin", description: "Visite de routine" },
  { name: "Emmener à l'école", description: "Déposer les enfants" },
  { name: "Récupérer à l'école", description: "Chercher les enfants" },
  { name: "Cours de piano", description: "Leçon hebdomadaire" },
  { name: "Entraînement de foot", description: "Stade municipal" },
  { name: "Nettoyer le frigo", description: "Jeter les périmés" },
  { name: "Faire le plein d'essence", description: "Station-service" },
  { name: "Réparer le vélo", description: "Changer la chaîne" },
  { name: "Ranger le garage", description: "Organiser les outils" },
  { name: "Nettoyer les vitres", description: "Intérieur et extérieur" },
  { name: "Recycler le carton", description: "Déchetterie" },
  { name: "Préparer le goûter", description: "Pour après l'école" },
  { name: "Réviser le permis", description: "Code de la route" },
  { name: "Téléphoner à mamie", description: "Prendre des nouvelles" },
  { name: "Installer nouvelle étagère", description: "Chambre d'enfant" },
  { name: "Nettoyer four", description: "Dégraisser" },
  { name: "Remplacer ampoule", description: "Salle de bain" },
  { name: "Tri des vêtements", description: "Donner ce qui ne va plus" },
  { name: "Commander pizza", description: "Vendredi soir" },
  { name: "Aller bibliothèque", description: "Rendre les livres" },
  { name: "Nettoyer cage hamster", description: "Changer litière" },
  { name: "Préparer valise", description: "Weekend chez les grands-parents" },
  { name: "Acheter cadeau anniversaire", description: "Pour copain d'école" },
  { name: "Réparer fuite robinet", description: "Cuisine" },
  { name: "Trier papiers administratifs", description: "Ranger documents" }
]

50.times do |i|
  template = task_templates[i % task_templates.length]

  # 50% des tâches assignées à Lois, 50% aux autres membres aléatoirement
  assignee = i < 25 ? lois_person : other_people.sample

  # Date cible entre aujourd'hui et +30 jours
  target_date = Date.today + rand(0..30)

  # 40% de tâches déjà terminées
  status = rand < 0.4

  task = Task.new(
    name: template[:name],
    description: template[:description],
    status: status,
    created_date: Date.today - rand(0..7),
    target_date: target_date,
    time: ["09:00", "14:00", "18:00", "20:00", nil].sample,
    user: lois,
    assignee: assignee
  )

  # Pour les tâches complétées, mettre à jour le updated_at pour simuler une complétion récente
  if status
    task.save!
    random_hours_ago = rand(1..48) # Entre 1h et 48h
    task.update_column(:updated_at, Time.now - random_hours_ago.hours)
  else
    task.save!
  end
end

puts "📅 Création de quelques événements..."
Event.create!(name: "Piscine", date: Date.today + 1, description: "Avec les enfants", place: "L'Espadon", user: lois)
Event.create!(name: "Patinoire", date: Date.today + 2, description: "Aussi avec les enfants", place: "Le Glaçon", user: lois)
Event.create!(name: "Cinéma", date: Date.today + 4, description: "Batman", place: "Le Magnifique", user: lois)

puts "✅ Seeds terminés !"
puts "   - #{Family.count} famille créée"
puts "   - #{User.count} utilisateur créé"
puts "   - #{Person.count} personnes créées"
puts "   - #{Task.count} tâches créées"
puts "   - #{Event.count} événements créés"
puts ""
puts "📊 Statistiques des tâches :"
puts "   - En cours : #{Task.where(status: [false, nil]).count}"
puts "   - Terminées : #{Task.where(status: true).count}"
puts ""
puts "👥 Répartition par personne :"
Person.all.each do |person|
  count = Task.where(assignee: person).count
  puts "   - #{person.name} : #{count} tâches"
end
