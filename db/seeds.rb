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
Event.destroy_all
User.destroy_all
Family.destroy_all

puts "👨‍👩‍👧‍👦 Création des familles..."
family = Family.create!(name: "Famille Maheu")
other_family = Family.create!(name: "Famille Martin")
third_family = Family.create!(name: "Famille Durand")

puts "👤 Création des utilisateurs..."
# Lois - 40 ans, enceinte de Jamie, vient de déménager à Bordeaux
lois = User.create!(
  email: "lois@example.com",
  password: "password",
  name: "Lois",
  status: "member",
  family: family,
  zipcode: "33000", # Bordeaux
  birthday: Date.new(1985, 5, 15)
)

paul_martin = User.create!(
  email: "paul@example.com",
  password: "password",
  name: "Paul Martin",
  status: "member",
  family: other_family,
  zipcode: "33000",
  birthday: Date.new(1982, 3, 12)
)

puts "👥 Création des membres de la famille Maheu..."
# Famille du pitch : Lois (40 ans, enceinte), Hal, Reese (17 ans), Malcolm (15 ans), Dewey (13 ans)
lois_person = Person.create!(name: "Lois", birthday: Date.new(1985, 5, 15), family: family, zipcode: "33000")
hal = Person.create!(name: "Hal", birthday: Date.new(1983, 3, 20), family: family, zipcode: "33000")
reese = Person.create!(name: "Reese", birthday: Date.new(2008, 2, 14), family: family, zipcode: "33000") # 18 ans le 14/02/2026
malcolm = Person.create!(name: "Malcolm", birthday: Date.new(2010, 6, 10), family: family, zipcode: "33000")
dewey = Person.create!(name: "Dewey", birthday: Date.new(2012, 9, 25), family: family, zipcode: "33000")

all_people = [lois_person, hal, reese, malcolm, dewey]
adults = [lois_person, hal]
children = [reese, malcolm, dewey]

puts "📋 Création des tâches réalistes..."

# Tâches par catégorie pour une famille nombreuse avec maman enceinte
adult_tasks = [
  { name: "Faire les courses", description: "Supermarché - liste sur le frigo" },
  { name: "Payer les factures", description: "Électricité, eau, internet - nouveau logement" },
  { name: "Rendez-vous sage-femme", description: "Suivi de grossesse - RDV mensuel" },
  { name: "Inscription cantine Dewey", description: "Nouvelle école - formulaire à compléter" },
  { name: "Inscription cantine Malcolm", description: "Nouveau collège - dossier à déposer" },
  { name: "Déballer les cartons", description: "Reste les cartons du garage" },
  { name: "Installer les meubles chambre Jamie", description: "Préparer la chambre du bébé" },
  { name: "Prendre RDV médecin traitant", description: "Trouver un nouveau médecin à Bordeaux" },
  { name: "Changer adresse carte grise", description: "Nouveau domicile à déclarer" },
  { name: "Inscrire les garçons au sport", description: "Trouver un club de foot pour les 3" },
  { name: "Acheter uniforme scolaire Reese", description: "Nouveau lycée exige un uniforme" },
  { name: "Renouveler assurance habitation", description: "Nouveau logement à assurer" },
  { name: "Transférer dossier médical", description: "Récupérer dossiers de l'ancienne ville" },
  { name: "Prendre RDV ophtalmo Malcolm", description: "Lunettes à vérifier" },
]

kids_tasks = [
  { name: "Faire les devoirs", description: "Mathématiques et français" },
  { name: "Réviser pour l'examen", description: "Bac blanc pour Reese" },
  { name: "Ranger la chambre", description: "Installer les affaires dans la nouvelle chambre" },
  { name: "Préparer son sac d'école", description: "Affaires pour demain" },
  { name: "Lire 30 minutes", description: "Lecture du soir" },
  { name: "Faire le lit", description: "Tous les matins" },
  { name: "Aider à déballer les cartons", description: "Ses propres affaires" },
]

shared_tasks = [
  { name: "Sortir les poubelles", description: "Jour de collecte" },
  { name: "Passer l'aspirateur", description: "Salon et couloir" },
  { name: "Faire la vaisselle", description: "Après le dîner" },
  { name: "Étendre le linge", description: "Mettre à sécher" },
  { name: "Plier le linge", description: "Ranger dans les armoires" },
  { name: "Nettoyer la salle de bain", description: "Lavabo et miroir" },
  { name: "Acheter du pain", description: "Boulangerie du coin" },
  { name: "Ranger le salon", description: "Garder propre" },
  { name: "Vider le lave-vaisselle", description: "Ranger la vaisselle" },
  { name: "Mettre la table", description: "Pour le dîner" },
]

# Créer des tâches avec des dates réalistes
created_tasks = []

# Tâches complétées récemment (déménagement, installation)
completed_tasks_data = [
  { name: "Signer le bail", description: "Nouveau logement à Bordeaux", assignee: lois_person },
  { name: "Faire le changement d'adresse", description: "La Poste - suivi du courrier", assignee: hal },
  { name: "Inscrire Reese au lycée", description: "Lycée Montaigne - dossier complet", assignee: lois_person },
  { name: "Inscrire Malcolm au collège", description: "Collège Aliénor d'Aquitaine", assignee: lois_person },
  { name: "Inscrire Dewey à l'école", description: "École primaire Jean Jaurès", assignee: hal },
  { name: "Installer la connexion internet", description: "Box livrée et configurée", assignee: hal },
  { name: "Déballer les cartons cuisine", description: "Tout est rangé !", assignee: lois_person },
  { name: "Monter les lits", description: "Chambres des garçons", assignee: hal },
  { name: "Première visite sage-femme Bordeaux", description: "Suivi de grossesse transféré", assignee: lois_person },
  { name: "Acheter électroménager", description: "Nouveau frigo et lave-linge", assignee: hal },
]

completed_tasks_data.each_with_index do |t, i|
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
  created_tasks << task
end

# Quelques tâches des enfants complétées
8.times do |i|
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
  { name: "RDV sage-femme", description: "Suivi grossesse 7ème mois - Clinique Bordeaux Nord", assignee: lois_person, target: Date.today, time: "14:00" },
  { name: "Faire les devoirs d'histoire", description: "Exposé sur la Révolution française", assignee: malcolm, target: Date.today, time: "17:00" },
  { name: "Sortir les poubelles", description: "Jour de collecte dans le nouveau quartier", assignee: reese, target: Date.today, time: "07:00" },
  { name: "Ranger sa nouvelle chambre", description: "Finir d'installer les affaires", assignee: dewey, target: Date.today, time: "18:00" },
  { name: "Faire les courses", description: "Supermarché - liste sur le frigo", assignee: hal, target: Date.today + 1, time: "10:00" },
  { name: "Inscription cantine Dewey", description: "Déposer le dossier à la mairie", assignee: lois_person, target: Date.today + 1, time: "09:00" },
  { name: "Réviser bac blanc maths", description: "Examen dans 3 jours", assignee: reese, target: Date.today + 1, time: "16:00" },
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
week_tasks = [
  { name: "Acheter uniforme lycée Reese", description: "Liste fournie par l'établissement", assignee: lois_person },
  { name: "Inscrire les garçons au foot", description: "Club FC Girondins - entraînement mercredi", assignee: hal },
  { name: "Déballer cartons du garage", description: "Outils et décorations", assignee: hal },
  { name: "Passer l'aspirateur", description: "Tout l'appartement", assignee: malcolm },
  { name: "Préparer chambre bébé", description: "Monter le lit et la commode", assignee: hal },
  { name: "Faire les devoirs de français", description: "Rédaction à rendre", assignee: dewey },
  { name: "Prendre RDV dentiste famille", description: "Trouver un dentiste à Bordeaux", assignee: lois_person },
]

week_tasks.each do |t|
  target_date = Date.today + rand(2..7)
  task = Task.create!(
    name: t[:name],
    description: t[:description],
    status: false,
    created_date: Date.today - rand(0..5),
    target_date: target_date,
    time: ["09:00", "14:00", "17:00", "18:00", nil].sample,
    user: lois,
    assignee: t[:assignee],
    family: family
  )
  created_tasks << task
end

# Tâches pour les semaines suivantes
15.times do |i|
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

# Quelques tâches en retard (charge mentale visible)
overdue_tasks = [
  { name: "Appeler l'assurance auto", description: "Mise à jour adresse", assignee: lois_person },
  { name: "Envoyer photos à mamie", description: "Photos du nouveau logement", assignee: lois_person },
  { name: "Réparer le vélo de Dewey", description: "Roue voilée", assignee: hal },
]

overdue_tasks.each do |t|
  overdue_days = rand(1..4)
  task = Task.create!(
    name: t[:name],
    description: t[:description],
    status: false,
    created_date: Date.today - overdue_days - rand(3..7),
    target_date: Date.today - overdue_days,
    time: ["09:00", "14:00", nil].sample,
    user: lois,
    assignee: t[:assignee],
    family: family
  )
  created_tasks << task
end

puts "📅 Création des événements communautaires (Bordeaux)..."

events_data = [
  {
    name: "Balade en vélo sur les quais",
    date: Date.today + 2,
    description: "Balade familiale le long de la Garonne. Parcours adapté aux enfants, 10km aller-retour. Pique-nique prévu à mi-chemin !",
    place: "Quais de Bordeaux",
    address: "Quai des Chartrons, 33000 Bordeaux",
    latitude: 44.8548,
    longitude: -0.5689,
    user: lois,
    category: "famille",
    max_participations: 20,
    participations_count: 8
  },
  {
    name: "Pique-nique au Parc Bordelais",
    date: Date.today + 3,
    description: "Rencontre entre familles du quartier. Chacun amène quelque chose à partager ! Aire de jeux pour les enfants.",
    place: "Parc Bordelais",
    address: "Rue du Bocage, 33000 Bordeaux",
    latitude: 44.8520,
    longitude: -0.6017,
    user: paul_martin,
    category: "social",
    max_participations: 30,
    participations_count: 12
  },
  {
    name: "Cours de yoga prénatal",
    date: Date.today + 4,
    description: "Séance adaptée aux futures mamans. Apportez votre tapis ! Animé par Sophie, sage-femme certifiée.",
    place: "Maison des Associations",
    address: "3 Rue du Cancera, 33000 Bordeaux",
    latitude: 44.8378,
    longitude: -0.5792,
    user: paul_martin,
    category: "sport",
    max_participations: 12,
    participations_count: 6
  },
  {
    name: "Troc de vêtements enfants",
    date: Date.today + 5,
    description: "Échangez les vêtements devenus trop petits. Toutes tailles de 0 à 16 ans. Gratuit et convivial !",
    place: "Centre Social Bordeaux Nord",
    address: "15 Rue Achard, 33000 Bordeaux",
    latitude: 44.8631,
    longitude: -0.5634,
    user: lois,
    category: "social",
    max_participations: 40,
    participations_count: 18
  },
  {
    name: "Visite guidée Bordeaux en famille",
    date: Date.today + 7,
    description: "Découverte ludique du centre historique adaptée aux enfants. Jeu de piste inclus !",
    place: "Place de la Bourse",
    address: "Place de la Bourse, 33000 Bordeaux",
    latitude: 44.8412,
    longitude: -0.5695,
    user: paul_martin,
    category: "culture",
    max_participations: 25,
    participations_count: 11
  },
  {
    name: "Atelier cuisine parents-enfants",
    date: Date.today + 10,
    description: "Préparez un repas ensemble ! Menu : quiche lorraine et tarte aux pommes. Ingrédients fournis.",
    place: "École de cuisine de Bordeaux",
    address: "20 Rue Vital Carles, 33000 Bordeaux",
    latitude: 44.8365,
    longitude: -0.5738,
    user: lois,
    category: "famille",
    max_participations: 16,
    participations_count: 10
  },
  {
    name: "Match de foot inter-quartiers",
    date: Date.today + 14,
    description: "Tournoi amical ouvert à tous. Catégories : enfants (8-12 ans), ados (13-17 ans) et adultes.",
    place: "Stade Chaban-Delmas",
    address: "Place Johnston, 33000 Bordeaux",
    latitude: 44.8273,
    longitude: -0.5995,
    user: paul_martin,
    category: "sport",
    max_participations: 50,
    participations_count: 28
  },
  {
    name: "Brocante de quartier",
    date: Date.today + 21,
    description: "Videz vos placards et faites de bonnes affaires ! Inscription gratuite pour les exposants.",
    place: "Place des Capucins",
    address: "Place des Capucins, 33000 Bordeaux",
    latitude: 44.8291,
    longitude: -0.5684,
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

# Événements de cette semaine
family_events_this_week = [
  {
    title: "RDV sage-femme",
    event_type: "medical",
    description: "Suivi de grossesse 7ème mois - Échographie prévue",
    start_date: Date.today,
    assigned_to: "Lois",
    location: "Clinique Bordeaux Nord, 33300 Bordeaux",
    time: Time.parse("14:00")
  },
  {
    title: "Conseil de classe Malcolm",
    event_type: "scolaire",
    description: "Premier conseil au nouveau collège - Présence des parents souhaitée",
    start_date: Date.today + 3,
    assigned_to: "Malcolm",
    location: "Collège Aliénor d'Aquitaine, salle 102",
    time: Time.parse("18:00")
  },
  {
    title: "Bac blanc Reese",
    event_type: "scolaire",
    description: "Épreuves de mathématiques et physique",
    start_date: Date.today + 4,
    end_date: Date.today + 5,
    assigned_to: "Reese",
    location: "Lycée Montaigne"
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
    description: "Malcolm fête ses 15 ans !",
    start_date: Date.new(Date.today.year, 6, 10),
    assigned_to: "Malcolm",
    location: "À la maison",
    time: Time.parse("14:00")
  },
  {
    title: "Anniversaire de Dewey",
    event_type: "anniversaire",
    description: "Dewey fête ses 13 ans !",
    start_date: Date.new(Date.today.year, 9, 25),
    assigned_to: "Dewey",
    location: "À la maison",
    time: Time.parse("15:00")
  },
  {
    title: "Naissance prévue Jamie",
    event_type: "medical",
    description: "Date prévue d'accouchement - Tout préparer avant !",
    start_date: Date.today + 60,
    assigned_to: "Lois",
    location: "Maternité Bordeaux"
  },
  {
    title: "Échographie 3ème trimestre",
    event_type: "medical",
    description: "Dernière échographie avant l'accouchement",
    start_date: Date.today + 14,
    assigned_to: "Lois",
    location: "Clinique Bordeaux Nord",
    time: Time.parse("10:00")
  },
  {
    title: "Vaccins rappel Dewey",
    event_type: "medical",
    description: "Rappel vaccins obligatoires - Carnet de santé",
    start_date: Date.today + 21,
    assigned_to: "Dewey",
    location: "Centre médical Bordeaux",
    time: Time.parse("09:30")
  },
  {
    title: "Réunion parents-profs Reese",
    event_type: "scolaire",
    description: "Premier trimestre au nouveau lycée",
    start_date: Date.today + 10,
    assigned_to: "Reese",
    location: "Lycée Montaigne",
    time: Time.parse("17:30")
  },
  {
    title: "Sortie scolaire musée d'Aquitaine",
    event_type: "scolaire",
    description: "Classe de Dewey - Prévoir pique-nique",
    start_date: Date.today + 12,
    assigned_to: "Dewey",
    location: "Musée d'Aquitaine, Bordeaux",
    time: Time.parse("08:30")
  },
  {
    title: "Inscription permis Reese",
    event_type: "autre",
    description: "Reese peut commencer le permis à 17 ans !",
    start_date: Date.today + 30,
    assigned_to: "Reese",
    location: "Auto-école Bordeaux Centre"
  },
  {
    title: "Visite maternité",
    event_type: "medical",
    description: "Visite des locaux et inscription",
    start_date: Date.today + 8,
    assigned_to: "Lois",
    location: "Maternité Bordeaux Nord",
    time: Time.parse("14:00")
  },
  {
    title: "Préparation accouchement",
    event_type: "medical",
    description: "Cours de préparation - séance 3/6",
    start_date: Date.today + 7,
    assigned_to: "Lois",
    location: "Cabinet sage-femme",
    time: Time.parse("10:00")
  },
  {
    title: "Dîner nouveaux voisins",
    event_type: "autre",
    description: "Invitation des voisins du 3ème - Apporter le dessert",
    start_date: Date.today + 11,
    location: "Chez les voisins",
    time: Time.parse("19:30")
  },
].each do |event_data|
  FamilyEvent.create!(
    family: family,
    reminders_enabled: true,
    **event_data
  )
end

puts "💬 Création des conversations..."

# Chat 1 - Question sur les événements de la semaine (comme dans le pitch)
chat1 = Chat.create!(user: lois, title: "Événements semaine")

Message.create!(
  chat: chat1,
  role: "user",
  content: "C'est quoi les événements de cette semaine ?"
)

Message.create!(
  chat: chat1,
  role: "assistant",
  content: "Voici les événements prévus cette semaine pour la famille Maheu :\n\n📅 **Cette semaine :**\n\n- **Aujourd'hui** : RDV sage-femme à 14h (Clinique Bordeaux Nord)\n- **Dans 3 jours** : Conseil de classe de Malcolm à 18h\n- **Dans 4-5 jours** : Bac blanc de Reese (maths et physique)\n\n🏠 **Pour le nouveau logement :**\nN'oubliez pas que Hal doit récupérer le colis à la Poste aujourd'hui !\n\nVoulez-vous que je vous rappelle autre chose ?"
)

# Chat 3 - Charge mentale et répartition (thème du pitch)
chat3 = Chat.create!(user: lois, title: "Répartition des tâches")

Message.create!(
  chat: chat3,
  role: "user",
  content: "J'ai l'impression de tout gérer toute seule, tu peux m'aider ?"
)

Message.create!(
  chat: chat3,
  role: "assistant",
  content: "Je comprends totalement, surtout avec le déménagement, trois ados et une grossesse ! 💪\n\nJ'ai analysé la répartition actuelle des tâches :\n\n**📊 Répartition actuelle :**\n- **Lois** : ~50% des tâches\n- **Hal** : ~15% des tâches\n- **Reese** : ~12% des tâches\n- **Malcolm** : ~12% des tâches\n- **Dewey** : ~11% des tâches\n\n**🔴 Constat :**\nLa charge est très déséquilibrée, surtout pour une maman enceinte de 7 mois !\n\n**💡 Suggestions :**\n\n1. **Hal peut prendre en charge :**\n   - Les courses hebdomadaires\n   - Les démarches administratives (carte grise, assurances)\n   - L'installation des meubles\n   - Les inscriptions sportives des garçons\n\n2. **Les garçons peuvent aider plus :**\n   - Reese (17 ans) : courses ponctuelles, cuisine simple\n   - Malcolm (15 ans) : ménage, vaisselle\n   - Dewey (13 ans) : rangement, petites courses\n\nVoulez-vous que je réattribue certaines tâches automatiquement ?"
)

# Chat 4 - Découverte de Bordeaux (famille nouvelle dans la ville)
chat4 = Chat.create!(user: lois, title: "Activités Bordeaux")

Message.create!(
  chat: chat4,
  role: "user",
  content: "On vient d'arriver à Bordeaux, qu'est-ce qu'on peut faire en famille ce weekend ?"
)

Message.create!(
  chat: chat4,
  role: "assistant",
  content: "Bienvenue à Bordeaux ! 🍷 Voici des idées pour découvrir votre nouvelle ville en famille :\n\n**🚴 Ce weekend - Événements communautaires :**\n- **Samedi** : Balade en vélo sur les quais (10km, adapté aux enfants)\n  → 4 familles déjà inscrites !\n- **Dimanche** : Pique-nique au Parc Bordelais\n  → 12 familles inscrites, aire de jeux sur place\n\n**🏛️ Incontournables à Bordeaux :**\n- Miroir d'eau (Place de la Bourse) - Les garçons vont adorer !\n- Cité du Vin - Espace famille avec ateliers\n- Parc Bordelais - Idéal pour les enfants\n- Quais de la Garonne - Parfait pour le vélo\n\n**🎯 Adapté à vos ados :**\n- Base sous-marine (expos street art)\n- Darwin Écosystème (skatepark, resto branché)\n- Escape games en ville\n\n**Pour Lois (enceinte) :**\nLe cours de yoga prénatal jeudi à la Maison des Associations - 6 places encore dispos !\n\nVoulez-vous vous inscrire à l'un de ces événements ?"
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
  pending = total - completed
  puts "   - #{person.name} : #{total} tâches (#{completed} terminées, #{pending} en cours)"
end
puts ""
puts "🗓️ Événements familiaux par type :"
FamilyEvent::EVENT_TYPES.each do |type, info|
  count = FamilyEvent.where(event_type: type).count
  puts "   - #{info[:icon]} #{info[:name]} : #{count}" if count > 0
end
puts ""
puts "👨‍👩‍👧‍👦 Famille Maheu :"
puts "   - Lois (40 ans, enceinte de Jamie)"
puts "   - Hal (42 ans)"
puts "   - Reese (17 ans - 18 ans le 14/02/2026)"
puts "   - Malcolm (15 ans)"
puts "   - Dewey (13 ans)"
puts "   - 📍 Bordeaux (33000)"
puts ""
puts "🔐 Connexion : lois@example.com / password"
