# The Village - Documentation V2

## Vue d'ensemble

The Village est une application Rails de gestion familiale et communautaire. Cette documentation couvre toutes les fonctionnalités, conventions et instructions pour les développeurs travaillant sur le projet.

---

## Table des matières

1. [Design System (DA)](#design-system-da)
2. [Architecture des fichiers](#architecture-des-fichiers)
3. [Composants principaux](#composants-principaux)
4. [Pages et fonctionnalités](#pages-et-fonctionnalités)
5. [Seeds et données de test](#seeds-et-données-de-test)
6. [Instructions pour les développeurs](#instructions-pour-les-développeurs)
7. [Conventions de code](#conventions-de-code)

---

## Design System (DA)

### Palette de couleurs

Le thème principal utilise un **gradient violet** cohérent sur toute l'application :

```scss
// Couleurs principales
$color-primary: #667eea;      // Violet clair
$color-secondary: #764ba2;    // Violet foncé

// Gradient principal (utilisé PARTOUT)
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);

// Variantes d'opacité pour les textes
// 100% - Titres principaux
// 70%  - Sous-titres, textes secondaires
// 60%  - Timestamps, métadonnées
// 8-15% - Backgrounds légers, hovers
```

### Application du gradient aux textes

Pour appliquer le gradient aux textes (effet "DA") :

```scss
.mon-texte-gradient {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

// Variante avec opacité (pour textes secondaires)
.mon-texte-gradient-light {
  background: linear-gradient(135deg, rgba(102, 126, 234, 0.7) 0%, rgba(118, 75, 162, 0.7) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
```

### Backgrounds avec gradient

```scss
// Background très léger (cartes, hovers)
background: linear-gradient(135deg, rgba(102, 126, 234, 0.08) 0%, rgba(118, 75, 162, 0.08) 100%);

// Background léger (sélection active)
background: linear-gradient(135deg, rgba(102, 126, 234, 0.15) 0%, rgba(118, 75, 162, 0.15) 100%);

// Bordure légère
border: 1px solid rgba(102, 126, 234, 0.15);
```

### Shadows avec couleur DA

```scss
// Shadow standard
box-shadow: 0 4px 12px rgba(102, 126, 234, 0.1);

// Shadow hover
box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2);

// Shadow focus (inputs)
box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
```

---

## Architecture des fichiers

### Structure principale

```
app/
├── assets/
│   └── stylesheets/
│       ├── application.scss
│       ├── config/
│       │   └── _design_tokens.scss    # Variables centralisées
│       ├── components/
│       │   ├── _cards.scss
│       │   ├── _buttons.scss
│       │   ├── _forms.scss
│       │   └── _chat_widget.scss
│       └── pages/
│
├── controllers/
│   ├── families_controller.rb         # Dashboard principal
│   ├── tasks_controller.rb            # Gestion des tâches
│   ├── events_controller.rb           # Événements communautaires
│   ├── family_events_controller.rb    # Calendrier familial
│   ├── chats_controller.rb            # Conversations IA
│   └── messages_controller.rb         # Messages du chat
│
├── helpers/
│   └── application_helper.rb          # Helper simple_markdown()
│
├── javascript/
│   └── controllers/
│       ├── village_alert_controller.js # Système d'alertes
│       ├── chat_widget_controller.js   # Widget chat flottant
│       └── pie_chart_controller.js     # Graphiques
│
├── models/
│   ├── user.rb
│   ├── family.rb
│   ├── person.rb                      # Membres de la famille
│   ├── task.rb
│   ├── event.rb                       # Événements communautaires
│   ├── family_event.rb                # Événements familiaux
│   ├── chat.rb
│   └── message.rb
│
└── views/
    ├── devise/
    │   ├── sessions/new.html.erb      # Page de connexion
    │   ├── registrations/new.html.erb # Page d'inscription
    │   └── passwords/new.html.erb     # Mot de passe oublié
    ├── families/
    │   └── show.html.erb              # Dashboard principal
    ├── tasks/
    │   └── index.html.erb             # Gestion des tâches
    ├── events/
    │   └── index.html.erb             # Communauté + carte
    ├── family_events/
    │   └── index.html.erb             # Calendrier familial
    └── shared/
        ├── _navbar.html.erb
        ├── _village_alert.html.erb    # Système d'alertes
        └── _chat_widget.html.erb      # Widget chat flottant
```

---

## Composants principaux

### 1. Village Alert (Système d'alertes)

**Fichiers concernés :**
- `app/views/shared/_village_alert.html.erb`
- `app/javascript/controllers/village_alert_controller.js`
- `app/views/layouts/application.html.erb` (intégration Turbo)

**Usage JavaScript :**

```javascript
// Alertes simples
VillageAlert.success("Tâche créée avec succès !");
VillageAlert.error("Une erreur est survenue");
VillageAlert.warning("Attention !");
VillageAlert.info("Information importante");

// Toast (petit, en bas à droite)
VillageAlert.toast("Modification enregistrée", "success");

// Confirmation (remplace le confirm natif)
VillageAlert.confirm("Supprimer cet élément ?", {
  danger: true,
  confirmText: "Supprimer",
  cancelText: "Annuler",
  onConfirm: () => { /* action */ },
  onCancel: () => { /* annulation */ }
});
```

**Intégration Turbo (confirmations automatiques) :**

Les confirmations Turbo (`data-turbo-confirm`) utilisent automatiquement VillageAlert grâce à `Turbo.setConfirmMethod()` configuré dans `application.html.erb`.

### 2. Chat Widget

**Fichiers concernés :**
- `app/views/shared/_chat_widget.html.erb` (widget flottant)
- `app/views/families/show.html.erb` (chat intégré au dashboard)
- `app/javascript/controllers/chat_widget_controller.js`

**Rendu Markdown :**

Les messages de l'assistant utilisent le helper `simple_markdown()` :

```ruby
# app/helpers/application_helper.rb
def simple_markdown(text)
  return "" if text.blank?

  escaped = ERB::Util.html_escape(text)
  escaped = escaped.gsub(/\*\*(.+?)\*\*/, '<strong>\1</strong>')  # **bold**
  escaped = escaped.gsub(/\*(.+?)\*/, '<em>\1</em>')              # *italic*
  escaped = escaped.gsub(/\n/, '<br>')                            # Retours ligne
  escaped = escaped.gsub(/^- (.+)/, '• \1')                       # Listes

  escaped.html_safe
end
```

**Usage dans les vues :**

```erb
<%= simple_markdown(message.content) %>
```

### 3. Carte Leaflet (Événements communautaires)

**Fichier :** `app/views/events/index.html.erb`

**Styles des popups (DA) :**

```scss
.event-popup strong {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.leaflet-popup-content-wrapper {
  border-radius: 12px;
  box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2);
  border: 1px solid rgba(102, 126, 234, 0.15);
}
```

### 4. Graphiques (Pie Chart)

**Fichier :** `app/javascript/controllers/pie_chart_controller.js`

Utilise Chart.js avec les couleurs DA.

---

## Pages et fonctionnalités

### Page de connexion / inscription

**Fichiers :**
- `app/views/devise/sessions/new.html.erb`
- `app/views/devise/registrations/new.html.erb`
- `app/views/devise/passwords/new.html.erb`

**Classes CSS importantes :**

```scss
.auth-title        // Titre avec gradient DA
.auth-subtitle     // Sous-titre avec gradient 70%
.auth-label        // Labels des champs
.auth-tabs         // Onglets Connexion/Inscription
.auth-input        // Inputs avec focus DA
.auth-link         // Liens avec gradient
```

**Onglet actif (texte blanc) :**

```scss
.auth-tabs .nav-link.active {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white !important;
  -webkit-text-fill-color: white;
}
```

### Dashboard (families/show)

**Fichier :** `app/views/families/show.html.erb`

**Sections :**
1. Stats cards (tâches, événements, membres, documents)
2. Village Assistant Chat (zone principale)
3. Liste des conversations (sidebar)
4. Événements à venir
5. Activité récente
6. Graphique de progression hebdomadaire

**Classes pour les conversations :**

```scss
.chat-item          // Item de conversation
.chat-item-active   // Conversation sélectionnée
.chat-item-title    // Titre avec gradient DA
.chat-item-preview  // Aperçu avec gradient 70%
.chat-item-time     // Timestamp avec gradient 60%
```

### Page des tâches

**Fichier :** `app/views/tasks/index.html.erb`

**Fonctionnalités :**
- Liste des tâches avec onglets (En cours, Terminées, Toutes)
- Sidebar sticky avec répartition par personne
- Graphiques (pie chart, contribution individuelle)
- Modal de création de tâche
- Suppression avec VillageAlert

**CSS Sticky sidebar :**

```scss
.tasks-row {
  align-items: stretch;
}

.sidebar-col {
  position: relative;
}

.sticky-sidebar {
  position: -webkit-sticky;
  position: sticky;
  top: 56px;  // Hauteur de la navbar
}
```

### Page communauté (events)

**Fichier :** `app/views/events/index.html.erb`

**Fonctionnalités :**
- Liste des événements en cards
- Carte Leaflet interactive
- Popups stylisés DA
- Filtres par catégorie

---

## Seeds et données de test

**Fichier :** `db/seeds.rb`

### Exécuter les seeds

```bash
bundle exec rails db:seed
```

### Données créées

| Modèle | Quantité | Description |
|--------|----------|-------------|
| Family | 3 | Maheu, Marshal, Durand |
| User | 3 | lois@example.com (principal) |
| Person | 5 | Lois, Hal, Malcolm, Reese, Dewey |
| Task | ~73 | Réparties logiquement |
| Event | 12 | Événements communautaires |
| FamilyEvent | 20 | Événements familiaux |
| Chat | 4 | Conversations avec l'assistant |
| Message | 12 | Messages avec markdown |

### Connexion test

```
Email: lois@example.com
Password: password
```

### Répartition des tâches

- **Complétées** : 25 (ces 2 dernières semaines)
- **En cours** : 48 (aujourd'hui → 30 jours)
- **En retard** : 5 (pour tester ce cas)

### Types d'événements familiaux

- Anniversaires (3)
- Gardes d'enfants (2)
- RDV médicaux (3)
- Événements scolaires (5)
- Vacances (2)
- Indisponibilités (2)
- Autres (3)

---

## Instructions pour les développeurs

### Ajouter un nouveau texte avec le style DA

```erb
<%# Dans une vue ERB %>
<h1 class="mon-titre" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; background-clip: text;">
  Mon titre
</h1>

<%# Ou avec une classe CSS %>
<h1 class="gradient-title">Mon titre</h1>
```

```scss
// Dans le fichier CSS/SCSS
.gradient-title {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}
```

### Ajouter une confirmation de suppression

La suppression utilise automatiquement VillageAlert si `data-turbo-confirm` est présent :

```erb
<%= button_to "Supprimer", task_path(@task),
    method: :delete,
    data: { turbo_confirm: "Êtes-vous sûr de vouloir supprimer cette tâche ?" } %>
```

### Afficher un message flash avec VillageAlert

Les flash messages sont automatiquement convertis en VillageAlert dans `application.html.erb`.

```ruby
# Dans un controller
redirect_to tasks_path, notice: "Tâche créée avec succès !"
# → VillageAlert.success("Tâche créée avec succès !")

redirect_to tasks_path, alert: "Une erreur est survenue"
# → VillageAlert.error("Une erreur est survenue")
```

### Ajouter du contenu avec markdown dans le chat

Les messages de l'assistant peuvent contenir :
- `**texte**` → **gras**
- `*texte*` → *italique*
- `- item` → • item (liste à puces)
- `\n` → retour à la ligne

```ruby
# Dans un seed ou controller
Message.create!(
  chat: chat,
  role: "assistant",
  content: "Voici les **points importants** :\n\n- Premier point\n- Deuxième point"
)
```

### Modifier les styles d'un composant existant

1. Identifier le fichier dans `app/assets/stylesheets/components/`
2. Utiliser les design tokens de `config/_design_tokens.scss`
3. Respecter le gradient DA (`#667eea` → `#764ba2`)

### Ajouter une nouvelle page

1. Créer le controller et la vue
2. Utiliser les classes existantes (`.stat-card`, `.dashboard-title`, etc.)
3. Ajouter les styles spécifiques dans `<style>` en fin de vue ou dans `pages/`
4. Respecter la DA pour tout nouveau texte/bouton/élément

---

## Conventions de code

### Couleurs

| Usage | Code |
|-------|------|
| Gradient principal | `linear-gradient(135deg, #667eea 0%, #764ba2 100%)` |
| Couleur primaire | `#667eea` |
| Couleur secondaire | `#764ba2` |
| Texte principal | `#374151` |
| Texte secondaire | `#6B7280` |

### Espacements

Utiliser les classes Bootstrap (`p-3`, `mb-4`, `gap-2`, etc.) autant que possible.

### Border radius

- Cards : `rounded-4` (16px)
- Boutons : `rounded-3` ou `rounded-pill`
- Inputs : `rounded-3`

### Shadows

```scss
// Card standard
box-shadow: 0 4px 12px rgba(102, 126, 234, 0.1);

// Hover
box-shadow: 0 8px 20px rgba(102, 126, 234, 0.2);
```

### Classes utilitaires fréquentes

```erb
<%# Titre de section %>
<h5 class="dashboard-section-title">Mon titre</h5>

<%# Titre de page %>
<h1 class="dashboard-title">Ma page</h1>

<%# Card statistique %>
<div class="card stat-card rounded-4">

<%# Lien avec gradient %>
<a href="#" class="gradient-link">Mon lien</a>

<%# Badge catégorie %>
<span class="badge category-badge">Catégorie</span>
```

---

## Checklist avant déploiement

- [ ] `bundle exec rails db:seed` fonctionne sans erreur
- [ ] Connexion avec `lois@example.com` / `password` fonctionne
- [ ] Dashboard affiche les données correctement
- [ ] Chat affiche le markdown (pas de `**` bruts)
- [ ] Confirmations de suppression utilisent VillageAlert
- [ ] Popups de carte sont stylisés DA
- [ ] Pages login/inscription sont stylisées DA
- [ ] Assets compilent sans erreur (`rails assets:precompile`)

---

## Historique des changements V2

### Améliorations visuelles
- Pages login/inscription redessinées avec DA
- Conversations (sidebar) en gradient DA
- Popups de carte Leaflet stylisés DA
- Bouton "Supprimer" en gradient DA (au lieu de rouge)

### Fonctionnalités
- Confirmations de suppression via VillageAlert (plus de confirm natif)
- Rendu markdown dans le chat (`**bold**` → **bold**)
- Sidebar sticky sur la page tâches
- Alignement des cartes graphiques

### Données
- Seeds enrichis et réalistes (73 tâches, 20 événements, 4 conversations)
- Conversations avec contenu markdown riche
- Répartition logique des tâches par âge (adultes vs enfants)

---

## Contact & Support

Pour toute question sur l'architecture ou les conventions :
- Consulter ce README en premier
- Voir le README des stylesheets (`app/assets/stylesheets/README.md`)
- Regarder les exemples dans les vues existantes
