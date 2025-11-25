# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Nettoyage de la base de données..."
Message.destroy_all
Chat.destroy_all
FamilyEvent.destroy_all
Task.destroy_all
Person.destroy_all
Event.destroy_all
User.destroy_all
Family.destroy_all

puts "👨‍👩‍👧‍👦 Création des familles..."
family = Family.create!(name: "Famille Maheu")
other_family = Family.create!(name: "Famille Marshal")
third_family = Family.create!(name: "Famille Durand")

puts "👤 Création des utilisateurs..."
lois = User.create!(
  email: "lois@example.com",
  password: "password",
  name: "Lois",
  status: "member",
  family: family,
  zipcode: "85000",
  birthday: Date.new(1985, 5, 15)
)

steve = User.create!(
  email: "steve@example.com",
  password: "password",
  name: "Steve Marshal",
  status: "member",
  family: other_family,
  zipcode: "75001",
  birthday: Date.new(1980, 8, 22)
)

puts "👥 Création des membres de la famille Maheu..."
lois_person = Person.create!(name: "Lois", birthday: Date.new(1985, 5, 15), family: family, zipcode: "85000")
hal = Person.create!(name: "Hal", birthday: Date.new(1983, 3, 20), family: family, zipcode: "85000")
malcolm = Person.create!(name: "Malcolm", birthday: Date.new(2010, 6, 10), family: family, zipcode: "85000")
reese = Person.create!(name: "Reese", birthday: Date.new(2008, 2, 14), family: family, zipcode: "85000")
dewey = Person.create!(name: "Dewey", birthday: Date.new(2012, 9, 25), family: family, zipcode: "85000")

all_people = [lois_person, hal, malcolm, reese, dewey]
adults = [lois_person, hal]
children = [malcolm, reese, dewey]

puts "📋 Création des tâches réalistes..."

# Tâches par catégorie avec assignation logique
adult_tasks = [
  { name: "Faire les courses", description: "Supermarché hebdomadaire - liste sur le frigo" },
  { name: "Payer les factures", description: "Électricité, eau, internet" },
  { name: "Rendez-vous dentiste", description: "Contrôle annuel" },
  { name: "Rendez-vous médecin", description: "Visite de routine" },
  { name: "Tondre la pelouse", description: "Jardin devant et derrière" },
  { name: "Laver la voiture", description: "Intérieur et extérieur" },
  { name: "Réparer fuite robinet", description: "Robinet de la cuisine qui goutte" },
  { name: "Installer nouvelle étagère", description: "Pour la chambre de Dewey" },
  { name: "Préparer le dîner", description: "Cuisiner pour toute la famille" },
  { name: "Acheter cadeau anniversaire copain", description: "Pour l'anniversaire de Tom samedi" },
  { name: "Téléphoner à mamie", description: "Prendre des nouvelles" },
  { name: "Renouveler assurance auto", description: "Échéance dans 2 semaines" },
  { name: "Prendre RDV ophtalmo", description: "Pour Malcolm - lunettes à vérifier" },
  { name: "Réserver restaurant anniversaire", description: "Pour les 15 ans de Malcolm" },
  { name: "Acheter fournitures scolaires", description: "Liste de rentrée" },
]

kids_tasks = [
  { name: "Faire les devoirs", description: "Mathématiques et français" },
  { name: "Réviser pour l'examen", description: "Histoire-géographie vendredi" },
  { name: "Ranger la chambre", description: "Tout bien organiser !" },
  { name: "Faire le lit", description: "Tous les matins" },
  { name: "Nourrir le chat", description: "Matin et soir" },
  { name: "Promener le chien", description: "Tour du quartier après l'école" },
  { name: "Arroser les plantes", description: "Plantes du salon" },
  { name: "Vider le lave-vaisselle", description: "Ranger la vaisselle propre" },
  { name: "Mettre la table", description: "Pour le dîner" },
  { name: "Débarrasser la table", description: "Après le repas" },
  { name: "Préparer son sac d'école", description: "Pour demain" },
  { name: "Lire 30 minutes", description: "Lecture du soir" },
]

shared_tasks = [
  { name: "Sortir les poubelles", description: "Poubelles jaunes et vertes" },
  { name: "Passer l'aspirateur", description: "Salon et couloir" },
  { name: "Faire la vaisselle", description: "Après le dîner" },
  { name: "Étendre le linge", description: "Mettre à sécher" },
  { name: "Plier le linge", description: "Ranger dans les armoires" },
  { name: "Nettoyer la salle de bain", description: "Lavabo et miroir" },
  { name: "Nettoyer la cuisine", description: "Plans de travail et évier" },
  { name: "Changer les draps", description: "Cette semaine" },
  { name: "Acheter du pain", description: "Boulangerie du coin" },
  { name: "Ranger le salon", description: "Avant les invités" },
  { name: "Nettoyer les vitres", description: "Fenêtres du salon" },
  { name: "Vider les poubelles des chambres", description: "Toutes les chambres" },
]

# Créer des tâches avec des dates réalistes
created_tasks = []

# Tâches complétées récemment (2 dernières semaines)
15.times do |i|
  template = (adult_tasks + shared_tasks).sample
  assignee = adults.sample
  completed_days_ago = rand(1..14)

  task = Task.create!(
    name: template[:name],
    description: template[:description],
    status: true,
    created_date: Date.today - completed_days_ago - rand(1..7),
    target_date: Date.today - completed_days_ago,
    time: ["09:00", "14:00", "18:00", nil].sample,
    user: lois,
    assignee: assignee,
    family: family
  )
  task.update_column(:updated_at, Time.now - completed_days_ago.days - rand(0..12).hours)
  created_tasks << task
end

# Tâches des enfants complétées
10.times do |i|
  template = kids_tasks.sample
  assignee = children.sample
  completed_days_ago = rand(1..10)

  task = Task.create!(
    name: template[:name],
    description: template[:description],
    status: true,
    created_date: Date.today - completed_days_ago - rand(1..5),
    target_date: Date.today - completed_days_ago,
    time: ["16:00", "17:00", "18:00", "19:00", nil].sample,
    user: lois,
    assignee: assignee,
    family: family
  )
  task.update_column(:updated_at, Time.now - completed_days_ago.days - rand(0..8).hours)
  created_tasks << task
end

# Tâches en cours pour aujourd'hui et demain
today_tasks = [
  { name: "Préparer le dîner", description: "Poulet rôti ce soir", assignee: lois_person, target: Date.today, time: "18:00" },
  { name: "Faire les devoirs de maths", description: "Exercices page 42", assignee: malcolm, target: Date.today, time: "17:00" },
  { name: "Sortir les poubelles", description: "C'est le jour de collecte", assignee: reese, target: Date.today, time: "07:00" },
  { name: "Promener le chien", description: "Balade du soir", assignee: dewey, target: Date.today, time: "18:30" },
  { name: "Faire les courses", description: "Liste sur le frigo", assignee: hal, target: Date.today + 1, time: "10:00" },
  { name: "Rendez-vous coiffeur", description: "Coupe pour Reese", assignee: reese, target: Date.today + 1, time: "14:00" },
  { name: "Préparer valise weekend", description: "Weekend chez mamie", assignee: malcolm, target: Date.today + 1, time: "19:00" },
  { name: "Nettoyer la voiture", description: "Avant le départ", assignee: hal, target: Date.today + 1, time: "09:00" },
]

today_tasks.each do |t|
  task = Task.create!(
    name: t[:name],
    description: t[:description],
    status: false,
    created_date: Date.today - rand(0..3),
    target_date: t[:target],
    time: t[:time],
    user: lois,
    assignee: t[:assignee],
    family: family
  )
  created_tasks << task
end

# Tâches pour cette semaine
15.times do |i|
  template = (shared_tasks + kids_tasks).sample
  assignee = all_people.sample
  target_date = Date.today + rand(2..7)

  task = Task.create!(
    name: template[:name],
    description: template[:description],
    status: false,
    created_date: Date.today - rand(0..5),
    target_date: target_date,
    time: ["09:00", "14:00", "17:00", "18:00", "19:00", nil].sample,
    user: lois,
    assignee: assignee,
    family: family
  )
  created_tasks << task
end

# Tâches pour les semaines suivantes
20.times do |i|
  template = (adult_tasks + shared_tasks + kids_tasks).sample
  assignee = all_people.sample
  target_date = Date.today + rand(8..30)

  task = Task.create!(
    name: template[:name],
    description: template[:description],
    status: false,
    created_date: Date.today - rand(0..7),
    target_date: target_date,
    time: ["09:00", "10:00", "14:00", "16:00", "18:00", nil].sample,
    user: lois,
    assignee: assignee,
    family: family
  )
  created_tasks << task
end

# Quelques tâches en retard
5.times do |i|
  template = shared_tasks.sample
  assignee = all_people.sample
  overdue_days = rand(1..5)

  task = Task.create!(
    name: template[:name],
    description: template[:description],
    status: false,
    created_date: Date.today - overdue_days - rand(3..7),
    target_date: Date.today - overdue_days,
    time: ["09:00", "14:00", nil].sample,
    user: lois,
    assignee: assignee,
    family: family
  )
  created_tasks << task
end

puts "📅 Création des événements communautaires..."

events_data = [
  {
    name: "Pique-nique au parc",
    date: Date.today + 2,
    description: "Grand pique-nique convivial entre voisins. Chacun amène quelque chose à partager ! Ambiance familiale garantie.",
    place: "Parc des Buttes-Chaumont",
    address: "1 Rue Botzaris, 75019 Paris",
    latitude: 48.8809,
    longitude: 2.3828,
    user: lois,
    category: "social",
    max_participations: 30,
    participations_count: 12
  },
  {
    name: "Cours de yoga en plein air",
    date: Date.today + 3,
    description: "Séance de yoga gratuite pour tous niveaux. Apportez votre tapis ! Session animée par Sophie, professeur certifiée.",
    place: "Jardin du Luxembourg",
    address: "Rue de Médicis, 75006 Paris",
    latitude: 48.8462,
    longitude: 2.3372,
    user: steve,
    category: "sport",
    max_participations: 20,
    participations_count: 15
  },
  {
    name: "Ciné-débat : documentaire écologie",
    date: Date.today + 5,
    description: "Projection du documentaire 'Demain' suivie d'un échange avec un expert en développement durable.",
    place: "MK2 Quai de Seine",
    address: "14 Quai de la Seine, 75019 Paris",
    latitude: 48.8849,
    longitude: 2.3749,
    user: steve,
    category: "culture",
    max_participations: 50,
    participations_count: 22
  },
  {
    name: "Troc de livres",
    date: Date.today + 6,
    description: "Amenez vos livres et repartez avec de nouvelles lectures. Romans, BD, livres jeunesse bienvenus !",
    place: "Bibliothèque François Truffaut",
    address: "4 Rue du Cinéma, 75001 Paris",
    latitude: 48.8610,
    longitude: 2.3473,
    user: lois,
    category: "culture",
    max_participations: 40,
    participations_count: 18
  },
  {
    name: "Tournoi de pétanque",
    date: Date.today + 7,
    description: "Tournoi amical ouvert à tous. Inscrivez votre équipe de 2 ! Lots à gagner et apéro offert.",
    place: "Place des Fêtes",
    address: "Place des Fêtes, 75019 Paris",
    latitude: 48.8769,
    longitude: 2.3931,
    user: steve,
    category: "sport",
    max_participations: 24,
    participations_count: 16
  },
  {
    name: "Fête des voisins",
    date: Date.today + 10,
    description: "Grande fête annuelle du quartier ! Chacun apporte un plat à partager. Musique et bonne ambiance.",
    place: "Cour de l'immeuble",
    address: "25 Rue du Faubourg Saint-Antoine, 75011 Paris",
    latitude: 48.8519,
    longitude: 2.3725,
    user: lois,
    category: "social",
    max_participations: 60,
    participations_count: 35
  },
  {
    name: "Randonnée familiale",
    date: Date.today + 14,
    description: "Balade de 5km dans le bois. Parcours adapté aux enfants et aux poussettes. Pique-nique prévu.",
    place: "Bois de Vincennes",
    address: "Route de la Pyramide, 75012 Paris",
    latitude: 48.8278,
    longitude: 2.4344,
    user: lois,
    category: "famille",
    max_participations: 25,
    participations_count: 11
  },
  {
    name: "Initiation au compostage",
    date: Date.today + 16,
    description: "Tout savoir sur le compostage en appartement et en maison. Conseils pratiques et distribution de composteurs.",
    place: "Mairie du 20ème",
    address: "6 Place Gambetta, 75020 Paris",
    latitude: 48.8636,
    longitude: 2.3984,
    user: steve,
    category: "jardinage",
    max_participations: 20,
    participations_count: 7
  },
  {
    name: "Vide-grenier du quartier",
    date: Date.today + 21,
    description: "Venez chiner ou vendre vos trésors ! Inscription gratuite pour les exposants du quartier.",
    place: "Place du marché",
    address: "Place du Commerce, 75015 Paris",
    latitude: 48.8420,
    longitude: 2.2957,
    user: lois,
    category: "social",
    max_participations: 100,
    participations_count: 45
  },
]

events_data.each do |event_data|
  Event.create!(event_data)
end

puts "🗓️ Création des événements familiaux..."

# Événements de cette semaine (important pour le dashboard)
family_events_this_week = [
  {
    title: "Hal en déplacement professionnel",
    event_type: "indisponibilite",
    description: "Conférence à Lyon - retour vendredi soir",
    start_date: Date.today + 2,
    end_date: Date.today + 4,
    assigned_to: "Hal"
  },
  {
    title: "Garde après l'école",
    event_type: "garde",
    description: "Hal récupère les enfants (si retour à temps)",
    start_date: Date.today + 3,
    assigned_to: "Hal",
    time: Time.parse("16:30")
  },
  {
    title: "Les enfants chez Mamie",
    event_type: "garde",
    description: "Weekend chez les grands-parents - préparer les valises !",
    start_date: Date.today + 5,
    end_date: Date.today + 7,
    assigned_to: "Malcolm",
    location: "Chez Mamie"
  },
  {
    title: "Match de foot Reese",
    event_type: "scolaire",
    description: "Tournoi inter-écoles",
    start_date: Date.today + 6,
    assigned_to: "Reese",
    location: "Stade municipal",
    time: Time.parse("14:00")
  },
]

family_events_this_week.each do |event_data|
  FamilyEvent.create!(
    family: family,
    reminders_enabled: true,
    **event_data
  )
end

# Événements des semaines suivantes
[
  {
    title: "Anniversaire de Malcolm",
    event_type: "anniversaire",
    description: "Malcolm fête ses 15 ans ! Organisation de la fête avec ses amis. Prévoir gâteau, décorations et activités.",
    start_date: Date.new(Date.today.year, 6, 10),
    assigned_to: "Malcolm",
    location: "À la maison",
    time: Time.parse("14:00")
  },
  {
    title: "Anniversaire de Dewey",
    event_type: "anniversaire",
    description: "Dewey fête ses 13 ans ! Thème dinosaures demandé.",
    start_date: Date.new(Date.today.year, 9, 25),
    assigned_to: "Dewey",
    location: "À la maison",
    time: Time.parse("15:00")
  },
  {
    title: "Anniversaire de mariage",
    event_type: "anniversaire",
    description: "20 ans de mariage ! Réserver restaurant ?",
    start_date: Date.new(Date.today.year, 7, 15),
    assigned_to: "Lois",
    location: "Restaurant gastronomique"
  },
  {
    title: "Dentiste Reese",
    event_type: "medical",
    description: "Contrôle annuel + détartrage - Prendre carnet de santé",
    start_date: Date.today + 10,
    assigned_to: "Reese",
    location: "Cabinet Dr Martin, 15 rue de la Santé",
    time: Time.parse("10:00")
  },
  {
    title: "Vaccins Dewey",
    event_type: "medical",
    description: "Rappel vaccins obligatoires - Ne pas oublier carnet !",
    start_date: Date.today + 14,
    assigned_to: "Dewey",
    location: "Centre médical Pasteur",
    time: Time.parse("09:30")
  },
  {
    title: "Ophtalmo Malcolm",
    event_type: "medical",
    description: "Contrôle de la vue - lunettes à vérifier",
    start_date: Date.today + 21,
    assigned_to: "Malcolm",
    location: "Centre d'ophtalmologie",
    time: Time.parse("11:00")
  },
  {
    title: "Réunion parents-profs",
    event_type: "scolaire",
    description: "Rencontre avec les professeurs de Malcolm - Tous les profs disponibles",
    start_date: Date.today + 8,
    assigned_to: "Malcolm",
    location: "Collège Jean Moulin, salle 204",
    time: Time.parse("18:00")
  },
  {
    title: "Spectacle de fin d'année",
    event_type: "scolaire",
    description: "Dewey joue le rôle principal dans la pièce de théâtre !",
    start_date: Date.today + 25,
    assigned_to: "Dewey",
    location: "École primaire - Gymnase",
    time: Time.parse("19:00")
  },
  {
    title: "Sortie scolaire musée",
    event_type: "scolaire",
    description: "Visite du musée d'histoire naturelle - Prévoir pique-nique",
    start_date: Date.today + 12,
    assigned_to: "Reese",
    location: "Musée d'histoire naturelle",
    time: Time.parse("08:30")
  },
  {
    title: "Conseil de classe Malcolm",
    event_type: "scolaire",
    description: "Présence des parents souhaitée",
    start_date: Date.today + 18,
    assigned_to: "Malcolm",
    location: "Collège Jean Moulin",
    time: Time.parse("17:30")
  },
  {
    title: "Vacances de Noël",
    event_type: "vacances",
    description: "Toute la famille part en montagne ! Ski et détente au programme.",
    start_date: Date.new(Date.today.year, 12, 21),
    end_date: Date.new(Date.today.year, 12, 31),
    location: "Chamonix - Chalet des Alpes"
  },
  {
    title: "Weekend à la mer",
    event_type: "vacances",
    description: "Petite escapade en famille - Hôtel réservé",
    start_date: Date.today + 28,
    end_date: Date.today + 30,
    location: "Les Sables-d'Olonne"
  },
  {
    title: "Lois en formation",
    event_type: "indisponibilite",
    description: "Formation professionnelle toute la journée",
    start_date: Date.today + 15,
    assigned_to: "Lois",
    time: Time.parse("09:00")
  },
  {
    title: "Réparation voiture",
    event_type: "autre",
    description: "Révision annuelle + contrôle technique - Voiture indisponible la journée",
    start_date: Date.today + 9,
    assigned_to: "Hal",
    location: "Garage Durand, Zone industrielle",
    time: Time.parse("08:00")
  },
  {
    title: "Dîner chez les Dupont",
    event_type: "autre",
    description: "Invitation des voisins - Apporter le dessert",
    start_date: Date.today + 11,
    location: "Chez les Dupont, 12 rue des Lilas",
    time: Time.parse("19:30")
  },
  {
    title: "Cours de piano Dewey",
    event_type: "autre",
    description: "Cours hebdomadaire avec Mme Duval",
    start_date: Date.today + 4,
    assigned_to: "Dewey",
    location: "École de musique",
    time: Time.parse("17:00")
  },
].each do |event_data|
  FamilyEvent.create!(
    family: family,
    reminders_enabled: true,
    **event_data
  )
end

puts "💬 Création des conversations..."

# Chat 1 - Question rapide sur les événements (celui qu'on voit sur le screenshot)
chat1 = Chat.create!(user: lois, title: "Question rapide")

Message.create!(
  chat: chat1,
  role: "user",
  content: "C'est quoi les événements de cette semaine ?"
)

Message.create!(
  chat: chat1,
  role: "assistant",
  content: "Voici les événements prévus cette semaine pour la famille Maheu :\n\n📅 **Cette semaine :**\n\n- **Dans 2 jours** : Hal en déplacement professionnel (jusqu'au #{(Date.today + 4).strftime('%d/%m')})\n- **Dans 3 jours** : Garde après l'école par Hal\n- **Dans 5 jours** : Les enfants chez Mamie (weekend)\n\nN'oubliez pas de préparer les valises des enfants pour le weekend chez Mamie ! Voulez-vous que je crée une tâche de rappel ?"
)

# Chat 2 - Anniversaire de Malcolm
chat2 = Chat.create!(user: lois, title: "Anniversaire Malcolm")

Message.create!(
  chat: chat2,
  role: "user",
  content: "L'anniversaire de Malcolm approche, tu peux m'aider à l'organiser ?"
)

Message.create!(
  chat: chat2,
  role: "assistant",
  content: "Bien sûr ! L'anniversaire de Malcolm est prévu le **10 juin**, il va avoir **15 ans** ! 🎂\n\nVoici ce que je vous suggère :\n\n**Préparatifs essentiels :**\n- 📝 Liste des invités (combien d'amis ?)\n- 🎂 Commander le gâteau (quel parfum aime-t-il ?)\n- 🎈 Décoration et ballons\n- 🎁 Idées cadeaux\n- 🍕 Menu (pizza party ?)\n\n**Activités possibles pour des ados de 15 ans :**\n- Tournoi de jeux vidéo\n- Escape game à domicile\n- Soirée film avec pop-corn\n- Karaoké\n\nQuel est votre budget approximatif ? Et Malcolm a-t-il exprimé des souhaits particuliers ?"
)

Message.create!(
  chat: chat2,
  role: "user",
  content: "Il veut inviter 8 copains, budget environ 200€"
)

Message.create!(
  chat: chat2,
  role: "assistant",
  content: "Parfait ! Avec **8 invités** et un budget de **200€**, voici ma proposition :\n\n**Répartition du budget :**\n- 🎂 Gâteau : ~40€\n- 🍕 Pizzas (3-4 grandes) : ~50€\n- 🥤 Boissons et snacks : ~30€\n- 🎈 Décorations : ~20€\n- 🎮 Location jeux/activité : ~40€\n- 🎁 Petit cadeau souvenir invités : ~20€\n\n**Planning suggéré :**\n- 14h : Arrivée des invités\n- 14h30 : Activités/jeux\n- 16h : Goûter et gâteau\n- 17h : Ouverture des cadeaux\n- 18h : Fin de la fête\n\nVoulez-vous que je crée des tâches pour les préparatifs ? Je peux aussi noter la date de commande du gâteau."
)

# Chat 3 - Organisation des tâches
chat3 = Chat.create!(user: lois, title: "Organisation des tâches")

Message.create!(
  chat: chat3,
  role: "user",
  content: "Comment mieux répartir les tâches entre les enfants ?"
)

Message.create!(
  chat: chat3,
  role: "assistant",
  content: "Excellente question ! Voici quelques conseils adaptés à l'âge de vos enfants :\n\n**Malcolm (14 ans) :**\n- Peut gérer des tâches plus complexes\n- Responsable de sa chambre + une pièce commune\n- Peut aider en cuisine (préparation, vaisselle)\n- Capable de s'occuper des plus jeunes ponctuellement\n\n**Reese (16 ans) :**\n- Tâches extérieures (poubelles, jardin léger)\n- Peut faire des courses simples\n- Responsabilités similaires à Malcolm\n\n**Dewey (12 ans) :**\n- Tâches plus simples et supervisées\n- Ranger sa chambre, faire son lit\n- Mettre/débarrasser la table\n- S'occuper des animaux\n\n**Astuces qui marchent :**\n- 📋 Planning visuel dans la cuisine\n- 🏆 Système de récompenses (argent de poche, sorties)\n- 🔄 Rotation des tâches chaque semaine\n- ⏰ Horaires fixes (avant/après école)\n\nVoulez-vous que je crée un planning type pour la semaine ?"
)

Message.create!(
  chat: chat3,
  role: "user",
  content: "Oui, fais-moi un planning pour cette semaine"
)

Message.create!(
  chat: chat3,
  role: "assistant",
  content: "Voici un planning équilibré pour cette semaine :\n\n**📅 Lundi - Vendredi (après l'école) :**\n\n| Tâche | Lun | Mar | Mer | Jeu | Ven |\n|-------|-----|-----|-----|-----|-----|\n| Sortir poubelles | Reese | - | Reese | - | Reese |\n| Table (mettre) | Dewey | Malcolm | Dewey | Malcolm | Dewey |\n| Table (débarrasser) | Malcolm | Dewey | Malcolm | Dewey | Malcolm |\n| Vaisselle | Malcolm | Reese | Dewey | Malcolm | Reese |\n| Nourrir chat | Dewey | Dewey | Dewey | Dewey | Dewey |\n\n**📅 Weekend :**\n\n**Samedi matin :**\n- Malcolm : Aspirateur salon\n- Reese : Nettoyage salle de bain\n- Dewey : Rangement salon + plantes\n\n**Dimanche :**\n- Repos bien mérité ! 😊\n- Juste les tâches habituelles (table, animaux)\n\nJe crée ces tâches dans l'application ?"
)

# Chat 4 - Aide culinaire
chat4 = Chat.create!(user: lois, title: "Idées repas semaine")

Message.create!(
  chat: chat4,
  role: "user",
  content: "Je n'ai plus d'idées pour les repas de la semaine, aide-moi !"
)

Message.create!(
  chat: chat4,
  role: "assistant",
  content: "Je comprends, c'est le casse-tête de beaucoup de familles ! 😅\n\nVoici des idées **simples et familiales** :\n\n**🍽️ Proposition de menu semaine :**\n\n**Lundi** : Pâtes à la bolognaise (classique qui plaît à tous)\n**Mardi** : Poulet rôti + haricots verts + purée\n**Mercredi** : Croque-monsieurs + salade (jour relax !)\n**Jeudi** : Hachis parmentier\n**Vendredi** : Pizza maison (les enfants peuvent aider !)\n**Samedi** : Burger maison + frites au four\n**Dimanche** : Rôti de porc + gratin dauphinois\n\n**💡 Astuces gain de temps :**\n- Préparer les légumes le dimanche\n- Doubler les quantités et congeler\n- Impliquer les enfants le mercredi\n\n**🛒 Liste de courses simplifiée :**\n- Viandes : poulet, bœuf haché, porc\n- Légumes : haricots, pommes de terre, tomates\n- Fromage, crème, œufs\n- Pâtes, pain de mie\n\nVoulez-vous que je crée une tâche 'courses' avec cette liste ?"
)

puts "✅ Seeds terminés !"
puts ""
puts "📊 Récapitulatif :"
puts "   - #{Family.count} familles créées"
puts "   - #{User.count} utilisateurs créés"
puts "   - #{Person.count} personnes créées"
puts "   - #{Task.count} tâches créées"
puts "   - #{Event.count} événements communautaires créés"
puts "   - #{FamilyEvent.count} événements familiaux créés"
puts "   - #{Chat.count} conversations créées"
puts "   - #{Message.count} messages créés"
puts ""
puts "📊 Statistiques des tâches :"
puts "   - En cours : #{Task.where(status: [false, nil]).count}"
puts "   - Terminées : #{Task.where(status: true).count}"
puts "   - En retard : #{Task.where(status: [false, nil]).where('target_date < ?', Date.today).count}"
puts ""
puts "👥 Répartition des tâches par personne :"
Person.where(family: family).each do |person|
  total = Task.where(assignee: person).count
  completed = Task.where(assignee: person, status: true).count
  puts "   - #{person.name} : #{total} tâches (#{completed} terminées)"
end
puts ""
puts "🗓️ Événements familiaux par type :"
FamilyEvent::EVENT_TYPES.each do |type, info|
  count = FamilyEvent.where(event_type: type).count
  puts "   - #{info[:icon]} #{info[:name]} : #{count}" if count > 0
end
puts ""
puts "🔐 Connexion : lois@example.com / password"
