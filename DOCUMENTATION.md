# E-Bar - Application de Gestion de Bar

## 📋 Description

E-Bar est une application mobile de gestion de bar développée avec Flutter (frontend) et Laravel (backend API). Elle permet de gérer efficacement les stocks, les ventes, les boissons et les utilisateurs dans un établissement de type bar ou café.

## 🏗️ Architecture

### Backend (API Laravel)
- **Framework**: Laravel 11
- **Base de données**: MySQL
- **Authentification**: Laravel Sanctum (Token-based)
- **Architecture**: RESTful API

### Frontend (Mobile Flutter)
- **Framework**: Flutter
- **Langage**: Dart
- **Architecture**: Stateful Widgets avec services centralisés

## 📱 Fonctionnalités

### 🎯 Gestion des Ventes
- **Enregistrement des ventes**: Ajout rapide de ventes avec sélection de boisson et quantité
- **Historique des ventes**: Consultation des ventes par date avec détails
- **Calcul automatique**: Total des ventes et chiffre d'affaires
- **Gestion du stock**: Déduction automatique du stock lors des ventes

### 📦 Gestion des Stocks
- **Ajout de stock**: Approvisionnement des boissons avec suivi des quantités
- **Consultation des stocks**: Vue d'ensemble des stocks disponibles
- **Suivi en temps réel**: Quantités actuelles et initiales
- **Alertes de stock**: Identification des stocks faibles

### 🥤 Gestion des Boissons
- **Catalogue de boissons**: Ajout et modification des boissons
- **Catégorisation**: Types de boissons (bières, softs, cocktails, etc.)
- **Prix**: Gestion des prix par boisson
- **Description**: Informations détaillées sur chaque boisson

### 👥 Gestion des Utilisateurs
- **Rôles et permissions**: Système de rôles (Admin, Vendeur, etc.)
- **Profils utilisateurs**: Informations et gestion des comptes
- **Authentification sécurisée**: Login avec tokens JWT
- **Historique d'actions**: Traçabilité des opérations

### 📊 Tableau de Bord
- **Statistiques en temps réel**: Vue d'ensemble des performances
- **Indicateurs clés**: Stock total, ventes, utilisateurs
- **Valeur des stocks**: Calcul automatique de la valeur du stock
- **Chiffre d'affaires**: Suivi des revenus

### 💰 Gestion des Clôtures
- **Clôtures automatiques**: Génération automatique des rapports journaliers
- **Rapports détaillés**: Ventilation des ventes par boisson
- **Historique des clôtures**: Archive des clôtures précédentes
- **Calculs automatiques**: Totaux et statistiques de fin de journée

## 🗂️ Structure des Données

### Modèles de Données

#### User (Utilisateur)
- `id`, `nom`, `email`, `password`
- `role_id`, `is_active`, `created_at`, `updated_at`

#### Role (Rôle)
- `id`, `nom`, `created_at`, `updated_at`

#### Boisson (Boisson)
- `id`, `nom`, `type_boisson_id`, `prix`
- `description`, `image`, `created_at`, `updated_at`

#### TypeBoisson (Type de Boisson)
- `id`, `type`, `created_at`, `updated_at`

#### Stock (Stock)
- `id`, `boisson_id`, `user_id`
- `quantite_initiale`, `quantite_actuelle`
- `created_at`, `updated_at`

#### Vente (Vente)
- `id`, `boisson_id`, `user_id`, `quantite`, `prix`
- `created_at`, `updated_at`

#### Cloture (Clôture)
- `id`, `user_id`, `date_cloture`, `montant_total`
- `created_at`, `updated_at`

#### ClotureDetail (Détail de Clôture)
- `id`, `cloture_id`, `boisson_id`
- `quantite_vendue`, `montant_vendu`
- `created_at`, `updated_at`

#### Historique (Historique)
- `id`, `user_id`, `type_action`, `details`
- `created_at`, `updated_at`

## 🚀 Installation et Configuration

### Prérequis
- **PHP**: 8.2+
- **Composer**: Dernière version
- **MySQL**: 8.0+
- **Flutter**: 3.0+
- **Dart**: 3.0+

### Backend (Laravel)

1. **Cloner le projet**
```bash
git clone [repository-url]
cd ebar
```

2. **Installer les dépendances**
```bash
composer install
```

3. **Configuration de l'environnement**
```bash
cp .env.example .env
php artisan key:generate
```

4. **Configurer la base de données**
```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=ebar
DB_USERNAME=votre_username
DB_PASSWORD=votre_password
```

5. **Migrer la base de données**
```bash
php artisan migrate
```

6. **Démarrer le serveur**
```bash
php artisan serve
```

### Frontend (Flutter)

1. **Naviguer vers le dossier application**
```bash
cd application
```

2. **Installer les dépendances**
```bash
flutter pub get
```

3. **Configurer l'URL de l'API**
Dans `lib/services/service.dart`, modifier `baseUrl`:
```dart
static const String baseUrl = 'http://votre-ip:8000/api';
```

4. **Lancer l'application**
```bash
flutter run
```

## 📡 API Endpoints

### Authentification
- `POST /api/login` - Connexion utilisateur
- `GET /api/user-profile` - Profil utilisateur
- `POST /api/logout` - Déconnexion

### Dashboard
- `GET /api/dashboard` - Statistiques générales

### Gestion des Stocks
- `GET /api/listeStock` - Liste des stocks
- `POST /api/ajouterStock` - Ajouter du stock

### Gestion des Ventes
- `GET /api/listeVente` - Liste des ventes
- `POST /api/ajouterVente` - Ajouter une vente

### Gestion des Boissons
- `GET /api/listeBoisson` - Liste des boissons
- `POST /api/ajouterBoisson` - Ajouter une boisson

### Gestion des Types de Boissons
- `GET /api/listeTypeBoisson` - Liste des types
- `POST /api/ajouterTypeBoisson` - Ajouter un type

### Gestion des Utilisateurs
- `GET /api/listeUser` - Liste des utilisateurs
- `POST /api/ajouterUser` - Ajouter un utilisateur

### Gestion des Clôtures
- `GET /api/listeCloture` - Liste des clôtures
- `POST /api/ajouterCloture` - Effectuer une clôture

### Historique
- `GET /api/historiques` - Historique des actions

## 🔐 Sécurité

### Authentification
- Tokens Laravel Sanctum
- Validation des entrées
- Protection CSRF

### Permissions
- Rôles basés sur les permissions
- Middleware de protection des routes

## 🎨 Interface Utilisateur

### Pages Principales

1. **Page d'accueil**: Tableau de bord avec statistiques
2. **Ventes**: Enregistrement et historique des ventes
3. **Stocks**: Gestion des stocks et approvisionnement
4. **Boissons**: Catalogue et gestion des boissons
5. **Utilisateurs**: Gestion des comptes et rôles
6. **Clôtures**: Rapports et fin de journée
7. **Paramètres**: Profil et configuration

### Design
- Interface moderne et intuitive
- Navigation fluide
- Responsive design
- Thème cohérent

## 📈 Fonctionnalités Avancées

### Calculs Automatiques
- Valeur du stock (quantité × prix)
- Chiffre d'affaires journalier
- Totaux de clôture automatiques

### Historique et Traçabilité
- Journal de toutes les actions
- Suivi des modifications
- Audit trail complet

### Notifications
- Messages de succès/erreur
- Alertes de stock faible
- Confirmations d'actions

## 🛠️ Technologies Utilisées

### Backend
- **Laravel 11**: Framework PHP
- **MySQL**: Base de données
- **Laravel Sanctum**: Authentification
- **Eloquent ORM**: Gestion des données

### Frontend
- **Flutter**: Framework mobile
- **Dart**: Langage de programmation
- **HTTP Package**: Communication API
- **ScreenUtil**: Design responsive

## 📝 Notes de Développement

### Conventions
- Code commenté et documenté
- Architecture MVC respectée
- API RESTful
- Gestion d'erreurs robuste

### Tests
- Validation des formulaires
- Tests unitaires recommandés
- Tests d'intégration API

## 🚀 Déploiement

### Production
- Configuration HTTPS
- Optimisation des performances
- Monitoring et logs
- Sauvegardes régulières

## 📞 Support

Pour toute question ou problème technique, veuillez contacter l'équipe de développement.

---

**Version**: 2.0  
**Dernière mise à jour**: Février 2026  
**Développeur**: Jonathan Kabongo
