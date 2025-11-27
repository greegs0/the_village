# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

puts "🌱 Nettoyage de la base de données..."
Message.destroy_all
Chat.destroy_all
Document.destroy_all
Folder.destroy_all
FamilyEvent.destroy_all
Task.destroy_all
Person.destroy_all
EventRegistration.destroy_all
Event.destroy_all
User.destroy_all
Family.destroy_all

puts "👨‍👩‍👧‍👦 Création des familles..."
family = Family.create!(name: "Famille Wilkerson")
family_martin = Family.create!(name: "Famille Martin")
family_durand = Family.create!(name: "Famille Durand")
family_bernard = Family.create!(name: "Famille Bernard")
family_petit = Family.create!(name: "Famille Petit")

puts "👤 Création des utilisateurs..."
# Lois - 40 ans, enceinte de Jamie, vient de déménager à Bordeaux
lois = User.create!(
  email: "lois@example.com",
  password: "password",
  name: "Lois",
  status: "member",
  family: family,
  zipcode: "33000",
  birthday: Date.new(1985, 5, 15)
)

paul_martin = User.create!(
  email: "paul@example.com",
  password: "password",
  name: "Paul Martin",
  status: "member",
  family: family_martin,
  zipcode: "33000",
  birthday: Date.new(1982, 3, 12)
)

sophie_durand = User.create!(
  email: "sophie@example.com",
  password: "password",
  name: "Sophie Durand",
  status: "member",
  family: family_durand,
  zipcode: "33000",
  birthday: Date.new(1988, 7, 22)
)

marc_durand = User.create!(
  email: "marc@example.com",
  password: "password",
  name: "Marc Durand",
  status: "member",
  family: family_durand,
  zipcode: "33000",
  birthday: Date.new(1986, 11, 5)
)

julie_bernard = User.create!(
  email: "julie@example.com",
  password: "password",
  name: "Julie Bernard",
  status: "member",
  family: family_bernard,
  zipcode: "33000",
  birthday: Date.new(1990, 4, 18)
)

thomas_petit = User.create!(
  email: "thomas@example.com",
  password: "password",
  name: "Thomas Petit",
  status: "member",
  family: family_petit,
  zipcode: "33000",
  birthday: Date.new(1985, 9, 30)
)

# Liste de tous les utilisateurs du quartier pour les inscriptions
all_neighbors = [lois, paul_martin, sophie_durand, marc_durand, julie_bernard, thomas_petit]

puts "👥 Création des membres de la famille Wilkerson..."
# Famille du pitch : Lois (40 ans, enceinte), Hal, Reese (17 ans), Malcolm (15 ans), Dewey (13 ans)
lois_person = Person.create!(name: "Lois", birthday: Date.new(1985, 5, 15), family: family, zipcode: "33000")
hal = Person.create!(name: "Hal", birthday: Date.new(1983, 3, 20), family: family, zipcode: "33000")
reese = Person.create!(name: "Reese", birthday: Date.new(2007, 2, 14), family: family, zipcode: "33000") # Aura 18 ans le 14/02
malcolm = Person.create!(name: "Malcolm", birthday: Date.new(2010, 6, 10), family: family, zipcode: "33000")
dewey = Person.create!(name: "Dewey", birthday: Date.new(2012, 9, 25), family: family, zipcode: "33000")

puts "👥 Création des membres de la famille Martin..."
Person.create!(name: "Paul Martin", birthday: Date.new(1982, 3, 12), family: family_martin, zipcode: "33000")
Person.create!(name: "Marie Martin", birthday: Date.new(1984, 8, 5), family: family_martin, zipcode: "33000")
Person.create!(name: "Léo Martin", birthday: Date.new(2015, 4, 20), family: family_martin, zipcode: "33000")

puts "👥 Création des membres de la famille Durand..."
Person.create!(name: "Sophie Durand", birthday: Date.new(1988, 7, 22), family: family_durand, zipcode: "33000")
Person.create!(name: "Marc Durand", birthday: Date.new(1986, 11, 5), family: family_durand, zipcode: "33000")
Person.create!(name: "Emma Durand", birthday: Date.new(2012, 3, 15), family: family_durand, zipcode: "33000")
Person.create!(name: "Lucas Durand", birthday: Date.new(2014, 9, 8), family: family_durand, zipcode: "33000")

puts "👥 Création des membres de la famille Bernard..."
Person.create!(name: "Julie Bernard", birthday: Date.new(1990, 4, 18), family: family_bernard, zipcode: "33000")
Person.create!(name: "Pierre Bernard", birthday: Date.new(1988, 7, 10), family: family_bernard, zipcode: "33000")
Person.create!(name: "Chloé Bernard", birthday: Date.new(2018, 2, 28), family: family_bernard, zipcode: "33000")

puts "👥 Création des membres de la famille Petit..."
Person.create!(name: "Thomas Petit", birthday: Date.new(1985, 9, 30), family: family_petit, zipcode: "33000")
Person.create!(name: "Laura Petit", birthday: Date.new(1987, 12, 3), family: family_petit, zipcode: "33000")
Person.create!(name: "Hugo Petit", birthday: Date.new(2013, 6, 17), family: family_petit, zipcode: "33000")

all_people = [lois_person, hal, reese, malcolm, dewey]
adults = [lois_person, hal]
children = [reese, malcolm, dewey]

puts "📁 Création des dossiers..."
# Dossiers pour la famille Wilkerson (documents à ajouter manuellement)
folder_medical = Folder.create!(name: "Médical", icon: "🏥", family: family)
folder_school = Folder.create!(name: "Scolarité", icon: "📚", family: family)
folder_admin = Folder.create!(name: "Administratif", icon: "📋", family: family)
folder_insurance = Folder.create!(name: "Assurances", icon: "🛡️", family: family)
folder_housing = Folder.create!(name: "Logement", icon: "🏠", family: family)

puts "📋 Création des tâches..."

# === TÂCHES POUR LA DÉMO ===
# Les 3 tâches mentionnées dans le script : "Inscription cantine Dewey", "RDV sage-femme", "Récupérer colis"
# NOTE: "Récupérer colis" (Poste) sera créé MANUELLEMENT pendant la démo par Hal
# NOTE: "Anniversaire Reese" sera créé MANUELLEMENT via l'assistant IA

# Tâches en cours visibles au début de la démo
# Répartition cible : Lois ~61%, Hal ~23%, enfants ~16%
# Total: 13 tâches en cours => Lois 8, Hal 3, enfants 2

# === TÂCHES LOIS (8 tâches = 61%) ===
# Les 3 mentionnées dans le script
Task.create!(
  name: "Inscription cantine Dewey",
  description: "Déposer le dossier à la mairie pour la nouvelle école",
  status: false,
  created_date: Date.today - 3,
  target_date: Date.today + 2,
  time: "09:00",
  user: lois,
  assignee: lois_person,
  family: family
)

Task.create!(
  name: "RDV sage-femme",
  description: "Suivi grossesse 7ème mois - Clinique Bordeaux Nord",
  status: false,
  created_date: Date.today - 5,
  target_date: Date.today + 1,
  time: "14:00",
  user: lois,
  assignee: lois_person,
  family: family
)

Task.create!(
  name: "Prendre RDV médecin traitant",
  description: "Trouver un nouveau médecin généraliste à Bordeaux",
  status: false,
  created_date: Date.today - 4,
  target_date: Date.today + 5,
  time: nil,
  user: lois,
  assignee: lois_person,
  family: family
)

Task.create!(
  name: "Changer adresse carte grise",
  description: "Nouveau domicile à déclarer - ANTS",
  status: false,
  created_date: Date.today - 7,
  target_date: Date.today + 3,
  time: nil,
  user: lois,
  assignee: lois_person,
  family: family
)

Task.create!(
  name: "Transférer dossier médical",
  description: "Récupérer les dossiers de l'ancienne ville",
  status: false,
  created_date: Date.today - 6,
  target_date: Date.today + 7,
  time: nil,
  user: lois,
  assignee: lois_person,
  family: family
)

Task.create!(
  name: "Acheter uniforme lycée Reese",
  description: "Liste fournie par le nouveau lycée",
  status: false,
  created_date: Date.today - 2,
  target_date: Date.today + 4,
  time: nil,
  user: lois,
  assignee: lois_person,
  family: family
)

Task.create!(
  name: "Appeler l'assurance habitation",
  description: "Mise à jour pour le nouveau logement",
  status: false,
  created_date: Date.today - 8,
  target_date: Date.today - 1, # en retard
  time: nil,
  user: lois,
  assignee: lois_person,
  family: family
)

Task.create!(
  name: "Envoyer photos à mamie",
  description: "Photos du nouveau logement à Bordeaux",
  status: false,
  created_date: Date.today - 5,
  target_date: Date.today - 2, # en retard
  time: nil,
  user: lois,
  assignee: lois_person,
  family: family
)

# === TÂCHES HAL (3 tâches = 23%) ===
Task.create!(
  name: "Faire les courses",
  description: "Supermarché - liste sur le frigo",
  status: false,
  created_date: Date.today - 1,
  target_date: Date.today + 2,
  time: "10:00",
  user: lois,
  assignee: hal,
  family: family
)

Task.create!(
  name: "Réparer le vélo de Dewey",
  description: "Roue voilée depuis le déménagement",
  status: false,
  created_date: Date.today - 6,
  target_date: Date.today - 3, # en retard
  time: nil,
  user: lois,
  assignee: hal,
  family: family
)

Task.create!(
  name: "Monter étagères garage",
  description: "Ranger les outils et cartons",
  status: false,
  created_date: Date.today - 4,
  target_date: Date.today + 6,
  time: nil,
  user: lois,
  assignee: hal,
  family: family
)

# === TÂCHES ENFANTS (2 tâches = 16%) ===
Task.create!(
  name: "Faire les devoirs d'histoire",
  description: "Exposé sur la Révolution française",
  status: false,
  created_date: Date.today - 1,
  target_date: Date.today,
  time: "17:00",
  user: lois,
  assignee: malcolm,
  family: family
)

Task.create!(
  name: "Ranger sa nouvelle chambre",
  description: "Finir d'installer les affaires",
  status: false,
  created_date: Date.today - 3,
  target_date: Date.today + 1,
  time: "18:00",
  user: lois,
  assignee: dewey,
  family: family
)

# === TÂCHES COMPLÉTÉES (historique) ===
completed_tasks_data = [
  { name: "Signer le bail", description: "Nouveau logement à Bordeaux", assignee: lois_person },
  { name: "Faire le changement d'adresse", description: "La Poste - suivi du courrier", assignee: hal },
  { name: "Inscrire Reese au lycée", description: "Lycée Montaigne - dossier complet", assignee: lois_person },
  { name: "Inscrire Malcolm au collège", description: "Collège Aliénor d'Aquitaine", assignee: lois_person },
  { name: "Inscrire Dewey à l'école", description: "École primaire Jean Jaurès", assignee: lois_person },
  { name: "Installer la connexion internet", description: "Box livrée et configurée", assignee: hal },
  { name: "Déballer les cartons cuisine", description: "Tout est rangé !", assignee: lois_person },
  { name: "Monter les lits", description: "Chambres des garçons", assignee: hal },
]

completed_tasks_data.each do |t|
  completed_days_ago = rand(3..14)
  task = Task.create!(
    name: t[:name],
    description: t[:description],
    status: true,
    created_date: Date.today - completed_days_ago - rand(1..7),
    target_date: Date.today - completed_days_ago,
    time: ["09:00", "14:00", "18:00", nil].sample,
    user: lois,
    assignee: t[:assignee],
    family: family
  )
  task.update_column(:updated_at, Time.now - completed_days_ago.days - rand(0..12).hours)
end

puts "📅 Création des événements communautaires (Bordeaux)..."

events_data = [
  {
    name: "Balade en vélo sur les quais",
    date: Date.today.next_occurring(:sunday),
    description: "Balade familiale le long de la Garonne. Parcours adapté aux enfants, 10km aller-retour. Pique-nique prévu à mi-chemin !",
    place: "Quais de Bordeaux",
    address: "Quai des Chartrons, 33000 Bordeaux",
    latitude: 44.8548,
    longitude: -0.5689,
    user: paul_martin,
    category: "famille",
    max_participations: 20,
    registrations: [paul_martin, sophie_durand, marc_durand, julie_bernard]
  },
  {
    name: "Pique-nique au Parc Bordelais",
    date: Date.today + 5,
    description: "Rencontre entre familles du quartier. Chacun amène quelque chose à partager ! Aire de jeux pour les enfants.",
    place: "Parc Bordelais",
    address: "Rue du Bocage, 33000 Bordeaux",
    latitude: 44.8520,
    longitude: -0.6017,
    user: paul_martin,
    category: "social",
    max_participations: 30,
    registrations: [lois, sophie_durand, marc_durand, julie_bernard, thomas_petit]
  },
  {
    name: "Cours de yoga prénatal",
    date: Date.today + 6,
    description: "Séance adaptée aux futures mamans. Apportez votre tapis ! Animé par Sophie, sage-femme certifiée.",
    place: "Maison des Associations",
    address: "3 Rue du Cancera, 33000 Bordeaux",
    latitude: 44.8378,
    longitude: -0.5792,
    user: sophie_durand,
    category: "sport",
    max_participations: 12,
    registrations: [lois, julie_bernard]
  },
  {
    name: "Troc de vêtements enfants",
    date: Date.today + 8,
    description: "Échangez les vêtements devenus trop petits. Toutes tailles de 0 à 16 ans. Gratuit et convivial !",
    place: "Centre Social Bordeaux Nord",
    address: "15 Rue Achard, 33000 Bordeaux",
    latitude: 44.8631,
    longitude: -0.5634,
    user: julie_bernard,
    category: "social",
    max_participations: 40,
    registrations: [lois, paul_martin, sophie_durand]
  },
  {
    name: "Visite guidée Bordeaux en famille",
    date: Date.today + 10,
    description: "Découverte ludique du centre historique adaptée aux enfants. Jeu de piste inclus !",
    place: "Place de la Bourse",
    address: "Place de la Bourse, 33000 Bordeaux",
    latitude: 44.8412,
    longitude: -0.5695,
    user: paul_martin,
    category: "culture",
    max_participations: 25,
    registrations: [lois, sophie_durand, marc_durand, thomas_petit]
  },
  {
    name: "Atelier cuisine parents-enfants",
    date: Date.today + 12,
    description: "Préparez un repas ensemble ! Menu : quiche lorraine et tarte aux pommes. Ingrédients fournis.",
    place: "École de cuisine de Bordeaux",
    address: "20 Rue Vital Carles, 33000 Bordeaux",
    latitude: 44.8365,
    longitude: -0.5738,
    user: julie_bernard,
    category: "famille",
    max_participations: 16,
    registrations: [lois, paul_martin, sophie_durand]
  },
  {
    name: "Match de foot inter-quartiers",
    date: Date.today + 14,
    description: "Tournoi amical ouvert à tous. Catégories : enfants (8-12 ans), ados (13-17 ans) et adultes.",
    place: "Stade Chaban-Delmas",
    address: "Place Johnston, 33000 Bordeaux",
    latitude: 44.8273,
    longitude: -0.5995,
    user: thomas_petit,
    category: "sport",
    max_participations: 50,
    registrations: [paul_martin, marc_durand, thomas_petit]
  },
  {
    name: "Brocante de quartier",
    date: Date.today + 21,
    description: "Videz vos placards et faites de bonnes affaires ! Inscription gratuite pour les exposants.",
    place: "Place des Capucins",
    address: "Place des Capucins, 33000 Bordeaux",
    latitude: 44.8291,
    longitude: -0.5684,
    user: thomas_petit,
    category: "social",
    max_participations: 100,
    registrations: [lois, paul_martin, sophie_durand, marc_durand, julie_bernard, thomas_petit]
  },
]

puts "🎫 Création des événements et inscriptions..."
events_data.each do |event_data|
  registrations = event_data.delete(:registrations) || []
  event = Event.create!(event_data)

  # Créer les inscriptions pour cet événement
  registrations.each do |user|
    EventRegistration.create!(event: event, user: user)
  end
end

puts "🗓️ Création des événements familiaux..."

# Début du mois de novembre 2025
november_start = Date.new(2025, 11, 1)

# Trouver les vendredis de novembre pour le poker de Hal
november_fridays = (november_start..november_start.end_of_month).select(&:friday?)

# === ÉVÉNEMENTS POUR CHAQUE JOUR DE NOVEMBRE ===
family_events = [
  # --- Semaine 1 (1-2 novembre) ---
  { title: "Toussaint - Repos", event_type: "autre", description: "Jour férié", start_date: Date.new(2025, 11, 1), location: "À la maison" },
  { title: "Visite cimetière", event_type: "autre", description: "Fleurir les tombes", start_date: Date.new(2025, 11, 2), location: "Cimetière Bordeaux", time: Time.parse("10:00") },

  # --- Semaine 2 (3-9 novembre) ---
  { title: "Rentrée après Toussaint", event_type: "scolaire", description: "Reprise des cours", start_date: Date.new(2025, 11, 3), assigned_to: "Dewey", location: "École Jean Jaurès", time: Time.parse("08:30") },
  { title: "Entraînement foot", event_type: "autre", description: "Entraînement hebdomadaire", start_date: Date.new(2025, 11, 4), assigned_to: "Malcolm", location: "FC Girondins", time: Time.parse("17:00") },
  { title: "Cours de piano Dewey", event_type: "autre", description: "Cours hebdomadaire", start_date: Date.new(2025, 11, 5), assigned_to: "Dewey", location: "Conservatoire", time: Time.parse("14:00") },
  { title: "RDV banque", event_type: "autre", description: "Changement d'adresse", start_date: Date.new(2025, 11, 6), assigned_to: "Lois", location: "Banque Bordeaux", time: Time.parse("10:00") },
  { title: "Hal Indisponible", event_type: "indisponibilite", description: "Soirée poker entre amis", start_date: Date.new(2025, 11, 7), assigned_to: "Hal", location: "Chez les copains", time: Time.parse("20:00") },
  { title: "Marché des Capucins", event_type: "autre", description: "Courses au marché", start_date: Date.new(2025, 11, 8), location: "Marché des Capucins", time: Time.parse("09:00") },
  { title: "Brunch famille", event_type: "autre", description: "Brunch dominical", start_date: Date.new(2025, 11, 9), location: "À la maison", time: Time.parse("11:00") },

  # --- Semaine 3 (10-16 novembre) ---
  { title: "Réunion parents-profs", event_type: "scolaire", description: "Rencontre avec les professeurs", start_date: Date.new(2025, 11, 10), assigned_to: "Reese", location: "Lycée Montaigne", time: Time.parse("17:30") },
  { title: "Entraînement foot", event_type: "autre", description: "Entraînement hebdomadaire", start_date: Date.new(2025, 11, 11), assigned_to: "Reese", location: "FC Girondins", time: Time.parse("18:00") },
  { title: "RDV ophtalmo Malcolm", event_type: "medical", description: "Contrôle vue", start_date: Date.new(2025, 11, 12), assigned_to: "Malcolm", location: "Ophtalmologue Bordeaux", time: Time.parse("16:30") },
  { title: "Sortie scolaire Dewey", event_type: "scolaire", description: "Visite musée d'Aquitaine", start_date: Date.new(2025, 11, 13), assigned_to: "Dewey", location: "Musée d'Aquitaine", time: Time.parse("08:30") },
  { title: "Hal Indisponible", event_type: "indisponibilite", description: "Soirée poker entre amis", start_date: Date.new(2025, 11, 14), assigned_to: "Hal", location: "Chez les copains", time: Time.parse("20:00") },
  { title: "Cinéma en famille", event_type: "autre", description: "Sortie ciné", start_date: Date.new(2025, 11, 15), location: "UGC Bordeaux", time: Time.parse("14:30") },
  { title: "Journée portes ouvertes", event_type: "scolaire", description: "Orientation Malcolm", start_date: Date.new(2025, 11, 16), assigned_to: "Malcolm", location: "Lycée Montaigne", time: Time.parse("09:00") },

  # --- Semaine 4 (17-23 novembre) ---
  { title: "RDV assurance", event_type: "autre", description: "Nouveau contrat habitation", start_date: Date.new(2025, 11, 17), assigned_to: "Hal", location: "Agence AXA", time: Time.parse("11:00") },
  { title: "Spectacle école Dewey", event_type: "scolaire", description: "Spectacle de fin de trimestre", start_date: Date.new(2025, 11, 18), assigned_to: "Dewey", location: "École Jean Jaurès", time: Time.parse("18:00") },
  { title: "Préparation accouchement", event_type: "medical", description: "Cours séance 4/6", start_date: Date.new(2025, 11, 19), assigned_to: "Lois", location: "Cabinet sage-femme", time: Time.parse("10:00") },
  { title: "Visite grands-parents", event_type: "autre", description: "Mamie et Papy arrivent", start_date: Date.new(2025, 11, 20), location: "À la maison" },
  { title: "Hal Indisponible", event_type: "indisponibilite", description: "Soirée poker entre amis", start_date: Date.new(2025, 11, 21), assigned_to: "Hal", location: "Chez les copains", time: Time.parse("20:00") },
  { title: "Départ grands-parents", event_type: "autre", description: "Au revoir Mamie et Papy", start_date: Date.new(2025, 11, 22), location: "Gare Bordeaux", time: Time.parse("14:00") },
  { title: "Match de foot Reese", event_type: "autre", description: "Match amical", start_date: Date.new(2025, 11, 23), assigned_to: "Reese", location: "Stade municipal", time: Time.parse("15:00") },

  # --- Semaine 5 (24-30 novembre) ---
  { title: "Échographie 3ème trimestre", event_type: "medical", description: "Dernière échographie", start_date: Date.new(2025, 11, 24), assigned_to: "Lois", location: "Clinique Bordeaux Nord", time: Time.parse("10:00") },
  { title: "Entraînement foot", event_type: "autre", description: "Entraînement hebdomadaire", start_date: Date.new(2025, 11, 25), assigned_to: "Malcolm", location: "FC Girondins", time: Time.parse("17:00") },
  { title: "Cours de piano Dewey", event_type: "autre", description: "Cours hebdomadaire", start_date: Date.new(2025, 11, 26), assigned_to: "Dewey", location: "Conservatoire", time: Time.parse("14:00") },
  { title: "RDV sage-femme", event_type: "medical", description: "Suivi de grossesse 7ème mois", start_date: Date.new(2025, 11, 27), assigned_to: "Lois", location: "Clinique Bordeaux Nord", time: Time.parse("14:00") },
  { title: "Hal Indisponible", event_type: "indisponibilite", description: "Soirée poker entre amis", start_date: Date.new(2025, 11, 28), assigned_to: "Hal", location: "Chez les copains", time: Time.parse("20:00") },
  { title: "Conseil de classe Malcolm", event_type: "scolaire", description: "Premier conseil nouveau collège", start_date: Date.new(2025, 11, 29), assigned_to: "Malcolm", location: "Collège Aliénor d'Aquitaine", time: Time.parse("18:00") },
  { title: "Vaccins rappel Dewey", event_type: "medical", description: "Rappel vaccins obligatoires", start_date: Date.new(2025, 11, 30), assigned_to: "Dewey", location: "Centre médical Bordeaux", time: Time.parse("09:30") },

  # --- Événements futurs importants ---
  { title: "Anniversaire oncle Bernard", event_type: "anniversaire", description: "Anniversaire proche", start_date: Date.new(2025, 12, 27), location: "Chez oncle Bernard", time: Time.parse("12:00") },
  { title: "Naissance prévue Jamie", event_type: "medical", description: "Date prévue d'accouchement", start_date: Date.new(2026, 1, 26), assigned_to: "Lois", location: "Maternité Bordeaux" },
]

family_events.each do |event_data|
  FamilyEvent.create!(
    family: family,
    reminders_enabled: true,
    **event_data
  )
end

puts "💬 Création des conversations..."

# Chat - Découverte de Bordeaux (famille nouvelle dans la ville)
chat1 = Chat.create!(user: lois, title: "Activités Bordeaux")

Message.create!(
  chat: chat1,
  role: "user",
  content: "On vient d'arriver à Bordeaux, qu'est-ce qu'on peut faire en famille ce weekend ?"
)

Message.create!(
  chat: chat1,
  role: "assistant",
  content: "Bienvenue à Bordeaux ! Voici des idées pour découvrir votre nouvelle ville en famille :\n\n**Ce weekend - Événements communautaires :**\n- **Dimanche** : Balade en vélo sur les quais (10km, adapté aux enfants)\n  → 4 familles déjà inscrites !\n\n**Incontournables à Bordeaux :**\n- Miroir d'eau (Place de la Bourse) - Les garçons vont adorer !\n- Cité du Vin - Espace famille avec ateliers\n- Parc Bordelais - Idéal pour les enfants\n- Quais de la Garonne - Parfait pour le vélo\n\n**Adapté à vos ados :**\n- Base sous-marine (expos street art)\n- Darwin Écosystème (skatepark, resto branché)\n\n**Pour Lois (enceinte) :**\nLe cours de yoga prénatal la semaine prochaine à la Maison des Associations !\n\nVoulez-vous vous inscrire à l'un de ces événements ?"
)

puts "✅ Seeds terminés !"
puts ""
puts "📊 Récapitulatif :"
puts "   - #{Family.count} familles créées"
puts "   - #{User.count} utilisateurs créés"
puts "   - #{Person.count} personnes créées"
puts "   - #{Task.count} tâches créées"
puts "   - #{Folder.count} dossiers créés"
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
puts "👥 Répartition des tâches par personne (en cours) :"
Person.where(family: family).each do |person|
  pending = Task.where(assignee: person, status: [false, nil]).count
  puts "   - #{person.name} : #{pending} tâches en cours"
end
puts ""
puts "📁 Dossiers créés (à remplir manuellement) :"
Folder.where(family: family).each do |folder|
  puts "   - #{folder.icon} #{folder.name}"
end
puts ""
puts "🗓️ Événements familiaux :"
FamilyEvent.where(family: family).order(:start_date).each do |event|
  puts "   - #{event.start_date.strftime('%d/%m')} : #{event.title}"
end
puts ""
puts "👨‍👩‍👧‍👦 Famille Wilkerson :"
puts "   - Lois (40 ans, enceinte de Jamie)"
puts "   - Hal (42 ans)"
puts "   - Reese (17 ans - 18 ans le 14/02)"
puts "   - Malcolm (15 ans)"
puts "   - Dewey (13 ans)"
puts "   - 📍 Bordeaux (33000)"
puts ""
puts "📝 À créer MANUELLEMENT pendant la démo :"
puts "   1. Tâche 'Aller chercher le colis à la poste' (Hal la crée)"
puts "   2. Chat 'Réattribuer les tâches équitablement'"
puts "   3. Chat 'Organiser les 18 ans de Reese le 14 février'"
puts ""
puts "🔐 Connexion : lois@example.com / password"
