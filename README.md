# 🏘️ The Village

> *"It takes a whole village to raise a happy family."* 👨‍👩‍👧‍👦

**The Village** est une plateforme de gestion familiale et communautaire qui aide les familles à coordonner leurs tâches quotidiennes, organiser leurs événements et rester connectées avec leur entourage.

---

## 🎯 Objectifs

### 🏠 Centraliser la vie de famille
Une seule application pour gérer les tâches ménagères, les rendez-vous médicaux, les activités scolaires et les moments en famille.

### 🤝 Simplifier la coordination
Assignez des tâches aux membres de la famille, suivez leur progression et célébrez les accomplissements ensemble.

### 🌍 Connecter la communauté
Découvrez les événements de votre quartier et partagez les vôtres avec les familles voisines.

### 🤖 Accompagner au quotidien
Un assistant IA intégré pour aider à planifier, organiser et répondre aux questions du quotidien familial.

---

## ✨ Fonctionnalités principales

### 📊 Dashboard Famille
- 📈 Vue d'ensemble des statistiques hebdomadaires
- ✅ Progression des tâches (terminées, en cours, en retard)
- 📅 Événements à venir sur 7 jours
- 🔔 Activité récente de la famille

### ✏️ Gestion des tâches
- 👤 Création et assignation de tâches aux membres
- ⏰ Suivi des échéances et du statut
- 📊 Statistiques par personne
- 🔍 Filtrage et organisation

### 📆 Calendrier familial
- 🎂 7 types d'événements : anniversaires, garde d'enfants, rendez-vous médicaux, événements scolaires, vacances, indisponibilités, autres
- 📅 Vue mensuelle avec filtres
- 🗓️ Support des événements multi-jours
- 📍 Géolocalisation des lieux

### 🎉 Événements communautaires
- ➕ Création d'événements publics
- 🗺️ Carte interactive des événements du quartier
- 🏷️ Catégories et filtres
- 👥 Gestion des participations

### 💬 Village Assistant
- 🤖 Chat IA conversationnel
- 💾 Historique des conversations
- 📝 Aide à la planification et à l'organisation
- ✍️ Support markdown pour les réponses formatées

---

## 🛠️ Stack technique

| Composant | Technologie |
|-----------|-------------|
| 🚂 Framework | Rails 7.1.6 |
| 💎 Ruby | 3.3.5 |
| 🐘 Base de données | PostgreSQL |
| 🔐 Authentification | Devise |
| 🎨 Frontend | Bootstrap 5.3 |
| ⚡ JavaScript | Stimulus.js, Turbo Rails |
| 🗺️ Cartes | Leaflet.js |
| 📊 Graphiques | Chart.js |

---

## 🚀 Installation

### 📋 Prérequis
- 💎 Ruby 3.3.5
- 🐘 PostgreSQL
- 📦 Node.js & Yarn

### ⚙️ Setup

```bash
# Cloner le repository
git clone git@github.com:greegs0/the_village.git
cd the_village

# Installer les dépendances
bundle install
yarn install

# Configurer la base de données
rails db:create
rails db:migrate
rails db:seed

# Lancer le serveur
bin/dev
```

🌐 L'application sera accessible sur `http://localhost:3000`

### 🧪 Comptes de test (après seed)

| 📧 Email | 🔑 Mot de passe | 👤 Rôle |
|----------|-----------------|---------|
| lois@example.com | password | Membre |
| steve@example.com| password | Membre |

---

## 🏗️ Architecture

```
the_village/
├── 📁 app/
│   ├── 🎮 controllers/     # Logique métier
│   ├── 📦 models/          # Modèles ActiveRecord
│   ├── 👁️ views/           # Templates ERB
│   ├── 🔧 helpers/         # Helpers Ruby
│   ├── ⚡ javascript/      # Stimulus controllers
│   └── 🎨 assets/          # CSS, images
├── ⚙️ config/              # Configuration Rails
├── 🗄️ db/                  # Migrations et seeds
└── 🧪 spec/                # Tests RSpec
```

### 📊 Modèles principaux

```
👤 User (Utilisateur)
├── 👨‍👩‍👧 Family (Famille)
│   ├── 🧑 Person (Membre de famille)
│   ├── ✅ Task (Tâche)
│   └── 📅 FamilyEvent (Événement familial)
├── 🤖 Chat (IA)
│   └── 💬 Message
└── 🎉 Event (Événement communautaire)
```

---

## 🎨 Design System

Le projet utilise un design artistique cohérent basé sur un dégradé violet :

- 🟣 **Couleur primaire** : `#667eea` → `#764ba2`
- 🌈 **Gradient** : `linear-gradient(135deg, #667eea 0%, #764ba2 100%)`

📖 Pour plus de détails sur les conventions de design, consultez [README_V2.md](app/assets/stylesheets/README_V2.md).

---

## 🤝 Contribution

1. 🌿 Créer une branche feature : `git checkout -b feature/ma-fonctionnalite`
2. 💾 Commiter les changements : `git commit -m "Add: ma fonctionnalité"`
3. 🚀 Pousser la branche : `git push origin feature/ma-fonctionnalite`
4. 🔀 Ouvrir une Pull Request vers `master`

### 📝 Conventions de commit

| Préfixe | Description |
|---------|-------------|
| ✨ `Add:` | Nouvelle fonctionnalité |
| 🐛 `Fix:` | Correction de bug |
| 📈 `Update:` | Amélioration d'une fonctionnalité existante |
| ♻️ `Refactor:` | Refactoring sans changement fonctionnel |
| 🎨 `Style:` | Changements CSS/UI uniquement |
| 📚 `Docs:` | Documentation |

---

## 👥 Équipe

Développé avec ❤️ par l'équipe The Village.

---

## 📄 Licence

Ce projet est privé et destiné à un usage interne. 🔒
