# TERMES DE RÉFÉRENCE - APPLICATION E-BAR

## 1. PRÉSENTATION GÉNÉRALE

### 1.1. Contexte du projet
L'application E-Bar est une solution de gestion numérique pour établissements de consommation (bars, restaurants, buvettes) développée en Flutter avec une architecture client-serveur utilisant Laravel comme backend.

### 1.2. Objectifs principaux
- Digitaliser la gestion des stocks et des ventes
- Automatiser le suivi des transactions commerciales
- Faciliter la gestion des utilisateurs et des rôles
- Fournir des statistiques en temps réel
- Simplifier la clôture des caisses

### 1.3. Portée du projet
Application mobile multiplateforme (Android/iOS) avec backend web pour la gestion centralisée des données.

## 2. SPÉCIFICATIONS FONCTIONNELLES

### 2.1. Module d'authentification
- **Connexion sécurisée** : Identifiant et mot de passe
- **Gestion des rôles** : Administrateur, Gérant, Vendeur
- **Session utilisateur** : Maintien de session sécurisée
- **Mot de passe oublié** : Récupération par email

### 2.2. Module de gestion des stocks
- **Ajout de boissons** : Référencement avec prix, quantité, type
- **Mise à jour des stocks** : Réapprovisionnement automatique
- **Suivi des stocks** : Alertes de seuil minimum
- **Types de boissons** : Catégorisation (bières, sodas, jus, etc.)

### 2.3. Module de gestion des ventes
- **Enregistrement des ventes** : Saisie rapide et intuitive
- **Calcul automatique** : Totalisation et remises
- **Historique des ventes** : Traçabilité complète
- **Validation des ventes** : Confirmation par utilisateur autorisé

### 2.4. Module de gestion des utilisateurs
- **Création de comptes** : Administration des utilisateurs
- **Gestion des rôles** : Attribution des permissions
- **Profils utilisateurs** : Informations personnelles
- **Désactivation** : Gestion des accès

### 2.5. Module de statistiques
- **Tableau de bord** : Vue synthétique des indicateurs
- **Valeur des stocks** : Initiale et actuelle
- **Volume des ventes** : Journalier, mensuel, annuel
- **Analytiques** : Produits les plus vendus, serveurs les plus actifs

### 2.6. Module de clôture
- **Clôture de caisse** : Automatisation quotidienne
- **Rapports de clôture** : Génération automatique
- **Validation** : Approbation par responsable
- **Archivage** : Conservation des données

## 3. SPÉCIFICATIONS TECHNIQUES

### 3.1. Architecture technique
- **Frontend** : Flutter 3.x
- **Backend** : Laravel 10.x (PHP 8.x)
- **Base de données** : MySQL 8.x
- **API** : RESTful avec JSON
- **Authentification** : JWT Token

### 3.2. Exigences de performance
- **Temps de réponse** : < 2 secondes pour les opérations standards
- **Support simultané** : 50+ utilisateurs concurrents
- **Base de données** : Optimisation des requêtes SQL
- **Cache** : Gestion intelligente des données temporaires

### 3.3. Sécurité
- **Chiffrement** : HTTPS obligatoire
- **Hashage** : Mot de passe avec bcrypt
- **Validation** : Input sanitization
- **Audit trail** : Journalisation des actions sensibles

### 3.4. Plateformes supportées
- **Mobile** : Android 8.0+ et iOS 12+
- **Responsive design** : Adaptation écran (430x932 référence)
- **Mode offline** : Fonctionnalités limitées sans connexion

## 4. MODULES DÉTAILLÉS

### 4.1. Navigation principale
- **Accueil** : Dashboard avec statistiques en temps réel
- **Ventes** : Gestion des transactions
- **Stocks** : Inventaire et approvisionnement
- **Utilisateurs** : Administration des comptes
- **Paramètres** : Configuration de l'application
- **À propos** : Informations sur l'application

### 4.2. Fonctionnalités par rôle

#### Administrateur
- Gestion complète de l'application
- Administration des utilisateurs
- Configuration système
- Accès à tous les rapports

#### Gérant
- Gestion des stocks et ventes
- Supervision des vendeurs
- Clôture des caisses
- Statistiques détaillées

#### Vendeur
- Enregistrement des ventes
- Consultation des stocks
- Historique personnel
- Profil utilisateur

## 5. BASE DE DONNÉES

### 5.1. Tables principales
- **users** : Utilisateurs et authentification
- **roles** : Définition des rôles et permissions
- **boissons** : Catalogue des produits
- **types_boissons** : Catégories de boissons
- **stocks** : Gestion des inventaires
- **ventes** : Enregistrement des transactions
- **clotures** : Rapports de clôture

### 5.2. Relations clés
- Users ↔ Roles (Many-to-Many)
- Boissons ↔ Types (Many-to-One)
- Ventes ↔ Users (Many-to-One)
- Stocks ↔ Boissons (Many-to-One)

## 6. INTERFACE UTILISATEUR

### 6.1. Design system
- **Thème** : Material Design 3
- **Couleurs** : Bleu principal (#2196F3), blanc, gris
- **Typographie** : Roboto, tailles adaptatives
- **Icônes** : Material Icons

### 6.2. Expérience utilisateur
- **Navigation intuitive** : Menu latéral ou bottom navigation
- **Feedback visuel** : Animations et transitions fluides
- **Accessibilité** : Support des lecteurs d'écran
- **Internationalisation** : Support multilingue (français par défaut)

## 7. DÉPLOIEMENT ET MAINTENANCE

### 7.1. Environnements
- **Développement** : Local avec Docker
- **Test** : Serveur de staging
- **Production** : Hébergement cloud

### 7.2. Maintenance
- **Mises à jour** : Déploiement progressif
- **Sauvegardes** : Quotidiennes automatisées
- **Monitoring** : Surveillance des performances
- **Support** : Assistance technique 24/7

## 8. LIVRABLES

### 8.1. Code source
- Application Flutter complète
- Backend Laravel avec API
- Scripts de base de données
- Documentation technique

### 8.2. Documentation
- Manuel utilisateur
- Guide d'administration
- Documentation API
- Procédures de déploiement

### 8.3. Tests
- Tests unitaires
- Tests d'intégration
- Tests d'acceptation utilisateur
- Tests de performance

## 9. CRITÈRES D'ACCEPTATION

### 9.1. Fonctionnalités
- [ ] Tous les modules opérationnels
- [ ] Authentification sécurisée
- [ ] Gestion des stocks en temps réel
- [ ] Rapports de clôture automatiques

### 9.2. Performance
- [ ] Temps de réponse < 2s
- [ ] Support 50+ utilisateurs
- [ ] Stabilité 99.9% uptime

### 9.3. Sécurité
- [ ] Chiffrement des données
- [ ] Validation des inputs
- [ ] Audit trail complet

## 10. CALENDRIER PRÉVISIONNEL

### Phase 1 (4 semaines) : Développement core
- Architecture et base de données
- Authentification et gestion utilisateurs
- Module de base des stocks

### Phase 2 (3 semaines) : Fonctionnalités avancées
- Module ventes et statistiques
- Interface utilisateur complète
- Tests et optimisation

### Phase 3 (2 semaines) : Finalisation
- Tests d'acceptation
- Documentation
- Déploiement production

---

**Version** : 1.0  
**Date** : Février 2026  
**Auteur** : Équipe de développement E-Bar  
**Statut** : Document de référence
