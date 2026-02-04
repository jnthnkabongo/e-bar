-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Feb 03, 2026 at 02:53 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ebar`
--

-- --------------------------------------------------------

--
-- Table structure for table `boissons`
--

CREATE TABLE `boissons` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nom` varchar(100) NOT NULL,
  `type_boisson_id` bigint(20) UNSIGNED NOT NULL,
  `prix` decimal(10,2) NOT NULL,
  `description` text DEFAULT NULL,
  `image` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `boissons`
--

INSERT INTO `boissons` (`id`, `nom`, `type_boisson_id`, `prix`, `description`, `image`, `created_at`, `updated_at`) VALUES
(1, 'Coca-Cola', 1, 3000.00, 'Soda populaire', 'coca.jpg', '2026-01-31 14:02:36', '2026-01-31 14:02:36'),
(2, 'Castel', 2, 7000.00, 'biere populaire', 'coca.jpg', '2026-01-31 14:07:56', '2026-01-31 14:07:56'),
(3, 'Fanta', 1, 5000.00, 'bralima', NULL, '2026-02-01 11:25:48', '2026-02-01 11:25:48'),
(4, 'Maltina', 1, 3500.00, 'bralima fournisseur', NULL, '2026-02-01 11:51:14', '2026-02-01 11:51:14'),
(5, 'Imperial', 3, 12000.00, 'fournisseur kin marche', NULL, '2026-02-01 12:13:48', '2026-02-01 12:13:48'),
(6, 'Vitalo pt', 1, 3500.00, 'fournisseur bralima', NULL, '2026-02-03 09:57:58', '2026-02-03 09:57:58');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clotures`
--

CREATE TABLE `clotures` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `date_cloture` date NOT NULL,
  `montant_total` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `clotures`
--

INSERT INTO `clotures` (`id`, `user_id`, `date_cloture`, `montant_total`, `created_at`, `updated_at`) VALUES
(1, 1, '2024-01-15', 40.00, '2026-01-31 14:12:31', '2026-01-31 14:12:31'),
(2, 3, '2026-02-02', 20000.00, '2026-02-02 15:49:31', '2026-02-02 15:49:31');

-- --------------------------------------------------------

--
-- Table structure for table `cloture_details`
--

CREATE TABLE `cloture_details` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `cloture_id` bigint(20) UNSIGNED NOT NULL,
  `boisson_id` bigint(20) UNSIGNED NOT NULL,
  `quantite_vendue` int(11) NOT NULL,
  `montant_vendu` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cloture_details`
--

INSERT INTO `cloture_details` (`id`, `cloture_id`, `boisson_id`, `quantite_vendue`, `montant_vendu`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 10, 25.00, '2026-01-31 14:12:31', '2026-01-31 14:12:31'),
(2, 1, 2, 5, 15.00, '2026-01-31 14:12:31', '2026-01-31 14:12:31'),
(3, 2, 3, 4, 20000.00, '2026-02-02 15:49:31', '2026-02-02 15:49:31');

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `historiques`
--

CREATE TABLE `historiques` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `type_action` varchar(50) NOT NULL,
  `details` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `historiques`
--

INSERT INTO `historiques` (`id`, `user_id`, `type_action`, `details`, `created_at`, `updated_at`) VALUES
(1, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-01-31 13:53:39', '2026-01-31 13:53:39'),
(2, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 13:54:07', '2026-01-31 13:54:07'),
(3, 1, 'Ajout Boisson', 'Ajout de la boisson: Coca-Cola', '2026-01-31 14:02:36', '2026-01-31 14:02:36'),
(4, 1, 'Ajout Stock', 'Ajout de 10 unités pour la boisson ID: 1', '2026-01-31 14:03:38', '2026-01-31 14:03:38'),
(5, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:04:29', '2026-01-31 14:04:29'),
(6, 1, 'Ajout Boisson', 'Ajout de la boisson: Castel', '2026-01-31 14:07:56', '2026-01-31 14:07:56'),
(7, 1, 'Ajout Stock', 'Ajout de 10 unités pour la boisson ID: 2', '2026-01-31 14:08:39', '2026-01-31 14:08:39'),
(8, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:09:08', '2026-01-31 14:09:08'),
(9, 1, 'Clôture', 'Clôture du 2024-01-15 - Total: 40', '2026-01-31 14:12:31', '2026-01-31 14:12:31'),
(10, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-01-31 14:14:12', '2026-01-31 14:14:12'),
(11, 1, 'Vente', 'Vente de 3 unités - Boisson ID: 1 - Montant: 7.5', '2026-01-31 14:15:34', '2026-01-31 14:15:34'),
(12, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-01-31 14:15:46', '2026-01-31 14:15:46'),
(13, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-01-31 14:31:22', '2026-01-31 14:31:22'),
(14, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:31:29', '2026-01-31 14:31:29'),
(15, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:31:46', '2026-01-31 14:31:46'),
(16, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:36:32', '2026-01-31 14:36:32'),
(17, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:38:17', '2026-01-31 14:38:17'),
(18, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-01-31 14:38:40', '2026-01-31 14:38:40'),
(19, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:38:46', '2026-01-31 14:38:46'),
(20, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:40:40', '2026-01-31 14:40:40'),
(21, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:42:43', '2026-01-31 14:42:43'),
(22, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:44:34', '2026-01-31 14:44:34'),
(23, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:44:42', '2026-01-31 14:44:42'),
(24, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:45:53', '2026-01-31 14:45:53'),
(25, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:46:03', '2026-01-31 14:46:03'),
(26, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:51:54', '2026-01-31 14:51:54'),
(27, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:54:41', '2026-01-31 14:54:41'),
(28, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:58:31', '2026-01-31 14:58:31'),
(29, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 14:59:52', '2026-01-31 14:59:52'),
(30, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 15:02:35', '2026-01-31 15:02:35'),
(31, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 15:03:32', '2026-01-31 15:03:32'),
(32, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-01-31 15:04:58', '2026-01-31 15:04:58'),
(33, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 15:19:29', '2026-01-31 15:19:29'),
(34, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-01-31 15:19:32', '2026-01-31 15:19:32'),
(35, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-01-31 15:20:13', '2026-01-31 15:20:13'),
(36, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 15:20:16', '2026-01-31 15:20:16'),
(37, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-01-31 15:20:17', '2026-01-31 15:20:17'),
(38, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-01-31 15:23:27', '2026-01-31 15:23:27'),
(39, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 15:23:28', '2026-01-31 15:23:28'),
(40, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-01-31 15:23:58', '2026-01-31 15:23:58'),
(41, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-01-31 15:24:26', '2026-01-31 15:24:26'),
(42, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 15:24:30', '2026-01-31 15:24:30'),
(43, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 15:25:06', '2026-01-31 15:25:06'),
(44, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-01-31 15:25:07', '2026-01-31 15:25:07'),
(45, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-01-31 15:27:09', '2026-01-31 15:27:09'),
(46, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 15:27:20', '2026-01-31 15:27:20'),
(47, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-01-31 15:27:22', '2026-01-31 15:27:22'),
(48, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-01-31 15:51:56', '2026-01-31 15:51:56'),
(49, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 15:51:58', '2026-01-31 15:51:58'),
(50, 1, 'Ajout utilisateur', 'Nouvel utilisateur ajouté: tabby kikwele (rabby@gmail.com)', '2026-01-31 15:56:38', '2026-01-31 15:56:38'),
(51, 1, 'Consultation Utilisateurs', 'A consulté la liste des utilisateurs', '2026-01-31 16:03:31', '2026-01-31 16:03:31'),
(52, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 16:06:18', '2026-01-31 16:06:18'),
(53, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 16:12:51', '2026-01-31 16:12:51'),
(54, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-01-31 16:13:23', '2026-01-31 16:13:23'),
(55, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 16:13:25', '2026-01-31 16:13:25'),
(56, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 16:14:18', '2026-01-31 16:14:18'),
(57, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 16:14:22', '2026-01-31 16:14:22'),
(58, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-01-31 16:14:24', '2026-01-31 16:14:24'),
(59, 1, 'Consultation Utilisateurs', 'A consulté la liste des utilisateurs', '2026-01-31 16:14:29', '2026-01-31 16:14:29'),
(60, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 16:15:31', '2026-01-31 16:15:31'),
(61, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-01-31 16:15:33', '2026-01-31 16:15:33'),
(62, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 18:44:10', '2026-01-31 18:44:10'),
(63, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-01-31 18:44:12', '2026-01-31 18:44:12'),
(64, 1, 'Consultation Utilisateurs', 'A consulté la liste des utilisateurs', '2026-01-31 18:44:19', '2026-01-31 18:44:19'),
(65, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 18:44:54', '2026-01-31 18:44:54'),
(66, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-01-31 18:45:02', '2026-01-31 18:45:02'),
(67, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 09:57:35', '2026-02-01 09:57:35'),
(68, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 09:57:40', '2026-02-01 09:57:40'),
(69, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 09:57:42', '2026-02-01 09:57:42'),
(70, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 10:59:52', '2026-02-01 10:59:52'),
(71, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 11:00:12', '2026-02-01 11:00:12'),
(72, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 11:00:31', '2026-02-01 11:00:31'),
(73, 1, 'Consultation Utilisateurs', 'A consulté la liste des utilisateurs', '2026-02-01 11:07:23', '2026-02-01 11:07:23'),
(74, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 11:08:08', '2026-02-01 11:08:08'),
(75, 1, 'Consultation Types Boissons', 'A consulté la liste des types de boissons', '2026-02-01 11:24:21', '2026-02-01 11:24:21'),
(76, 1, 'Consultation Types Boissons', 'A consulté la liste des types de boissons', '2026-02-01 11:25:15', '2026-02-01 11:25:15'),
(77, 1, 'Ajout Boisson', 'Ajout de la boisson: fanta', '2026-02-01 11:25:48', '2026-02-01 11:25:48'),
(78, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 11:29:58', '2026-02-01 11:29:58'),
(79, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 11:32:54', '2026-02-01 11:32:54'),
(80, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 11:34:13', '2026-02-01 11:34:13'),
(81, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 11:34:19', '2026-02-01 11:34:19'),
(82, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 11:34:21', '2026-02-01 11:34:21'),
(83, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 11:37:18', '2026-02-01 11:37:18'),
(84, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 11:37:19', '2026-02-01 11:37:19'),
(85, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 11:37:37', '2026-02-01 11:37:37'),
(86, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 11:38:02', '2026-02-01 11:38:02'),
(87, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 11:38:34', '2026-02-01 11:38:34'),
(88, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 11:40:04', '2026-02-01 11:40:04'),
(89, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 11:42:46', '2026-02-01 11:42:46'),
(90, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 11:43:24', '2026-02-01 11:43:24'),
(91, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 11:44:27', '2026-02-01 11:44:27'),
(92, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 11:44:29', '2026-02-01 11:44:29'),
(93, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 11:46:58', '2026-02-01 11:46:58'),
(94, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 11:47:00', '2026-02-01 11:47:00'),
(95, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 11:49:48', '2026-02-01 11:49:48'),
(96, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 11:49:49', '2026-02-01 11:49:49'),
(97, 1, 'Ajout Stock', 'Ajout de 16 unités pour la boisson ID: 3', '2026-02-01 11:50:05', '2026-02-01 11:50:05'),
(98, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 11:50:12', '2026-02-01 11:50:12'),
(99, 1, 'Consultation Types Boissons', 'A consulté la liste des types de boissons', '2026-02-01 11:50:50', '2026-02-01 11:50:50'),
(100, 1, 'Ajout Boisson', 'Ajout de la boisson: Maltina', '2026-02-01 11:51:14', '2026-02-01 11:51:14'),
(101, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 11:51:17', '2026-02-01 11:51:17'),
(102, 1, 'Ajout Stock', 'Ajout de 20 unités pour la boisson ID: 4', '2026-02-01 11:51:23', '2026-02-01 11:51:23'),
(103, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 11:51:29', '2026-02-01 11:51:29'),
(104, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 11:51:52', '2026-02-01 11:51:52'),
(105, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 11:52:10', '2026-02-01 11:52:10'),
(106, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 12:03:51', '2026-02-01 12:03:51'),
(107, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 12:03:59', '2026-02-01 12:03:59'),
(108, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 12:07:43', '2026-02-01 12:07:43'),
(109, 1, 'Ajout Type Boisson', 'Nouveau type de boisson ajouté: whisky', '2026-02-01 12:10:19', '2026-02-01 12:10:19'),
(110, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 12:10:26', '2026-02-01 12:10:26'),
(111, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 12:11:07', '2026-02-01 12:11:07'),
(112, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 12:11:10', '2026-02-01 12:11:10'),
(113, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 12:11:44', '2026-02-01 12:11:44'),
(114, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 12:12:29', '2026-02-01 12:12:29'),
(115, 1, 'Consultation Types Boissons', 'A consulté la liste des types de boissons', '2026-02-01 12:12:59', '2026-02-01 12:12:59'),
(116, 1, 'Ajout Boisson', 'Ajout de la boisson: Imperial', '2026-02-01 12:13:48', '2026-02-01 12:13:48'),
(117, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 12:13:56', '2026-02-01 12:13:56'),
(118, 1, 'Ajout Stock', 'Ajout de 5 unités pour la boisson ID: 5', '2026-02-01 12:14:05', '2026-02-01 12:14:05'),
(119, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 12:14:09', '2026-02-01 12:14:09'),
(120, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 12:17:12', '2026-02-01 12:17:12'),
(121, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 12:42:00', '2026-02-01 12:42:00'),
(122, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 12:42:04', '2026-02-01 12:42:04'),
(123, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 12:42:37', '2026-02-01 12:42:37'),
(124, 1, 'Consultation Types Boissons', 'A consulté la liste des types de boissons', '2026-02-01 12:42:39', '2026-02-01 12:42:39'),
(125, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 12:42:45', '2026-02-01 12:42:45'),
(126, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 12:45:09', '2026-02-01 12:45:09'),
(127, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 12:49:50', '2026-02-01 12:49:50'),
(128, 1, 'Consultation Types Boissons', 'A consulté la liste des types de boissons', '2026-02-01 12:49:53', '2026-02-01 12:49:53'),
(129, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 12:50:12', '2026-02-01 12:50:12'),
(130, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 12:57:32', '2026-02-01 12:57:32'),
(131, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 12:57:33', '2026-02-01 12:57:33'),
(132, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 12:57:54', '2026-02-01 12:57:54'),
(133, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 12:57:56', '2026-02-01 12:57:56'),
(134, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 13:06:04', '2026-02-01 13:06:04'),
(135, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 13:06:05', '2026-02-01 13:06:05'),
(136, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 13:41:11', '2026-02-01 13:41:11'),
(137, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:09:37', '2026-02-01 14:09:37'),
(138, 1, 'Consultation Utilisateurs', 'A consulté la liste des utilisateurs', '2026-02-01 14:09:49', '2026-02-01 14:09:49'),
(139, 1, 'Consultation Utilisateurs', 'A consulté la liste des utilisateurs', '2026-02-01 14:11:00', '2026-02-01 14:11:00'),
(140, 1, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 14:11:12', '2026-02-01 14:11:12'),
(141, 2, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:11:23', '2026-02-01 14:11:23'),
(142, 2, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:13:17', '2026-02-01 14:13:17'),
(143, 2, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 14:14:28', '2026-02-01 14:14:28'),
(144, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:14:48', '2026-02-01 14:14:48'),
(145, 1, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 14:15:43', '2026-02-01 14:15:43'),
(146, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:15:57', '2026-02-01 14:15:57'),
(147, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:16:50', '2026-02-01 14:16:50'),
(148, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:18:04', '2026-02-01 14:18:04'),
(149, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 14:18:11', '2026-02-01 14:18:11'),
(150, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 14:18:12', '2026-02-01 14:18:12'),
(151, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:21:41', '2026-02-01 14:21:41'),
(152, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 14:21:50', '2026-02-01 14:21:50'),
(153, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 14:21:51', '2026-02-01 14:21:51'),
(154, 1, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 14:21:56', '2026-02-01 14:21:56'),
(155, 2, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:22:08', '2026-02-01 14:22:08'),
(156, 2, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:25:15', '2026-02-01 14:25:15'),
(157, 2, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 14:25:24', '2026-02-01 14:25:24'),
(158, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:25:38', '2026-02-01 14:25:38'),
(159, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 14:25:43', '2026-02-01 14:25:43'),
(160, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 14:25:44', '2026-02-01 14:25:44'),
(161, 1, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 14:25:49', '2026-02-01 14:25:49'),
(162, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:31:28', '2026-02-01 14:31:28'),
(163, 1, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 14:31:53', '2026-02-01 14:31:53'),
(164, 2, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:32:11', '2026-02-01 14:32:11'),
(165, 2, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 14:36:29', '2026-02-01 14:36:29'),
(166, 2, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:36:43', '2026-02-01 14:36:43'),
(167, 2, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 14:36:53', '2026-02-01 14:36:53'),
(168, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:37:07', '2026-02-01 14:37:07'),
(169, 1, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 14:37:13', '2026-02-01 14:37:13'),
(170, 2, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:37:24', '2026-02-01 14:37:24'),
(171, 2, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:38:56', '2026-02-01 14:38:56'),
(172, 2, 'Consultation Utilisateurs', 'A consulté la liste des utilisateurs', '2026-02-01 14:39:01', '2026-02-01 14:39:01'),
(173, 2, 'Ajout utilisateur', 'Nouvel utilisateur ajouté: chido tshimanga kalonji (chido@gmail.com)', '2026-02-01 14:39:53', '2026-02-01 14:39:53'),
(174, 2, 'Consultation Utilisateurs', 'A consulté la liste des utilisateurs', '2026-02-01 14:39:54', '2026-02-01 14:39:54'),
(175, 2, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 14:40:16', '2026-02-01 14:40:16'),
(176, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:41:04', '2026-02-01 14:41:04'),
(177, 1, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 14:41:08', '2026-02-01 14:41:08'),
(178, 2, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:41:19', '2026-02-01 14:41:19'),
(179, 2, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 14:41:23', '2026-02-01 14:41:23'),
(180, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:41:33', '2026-02-01 14:41:33'),
(181, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:42:10', '2026-02-01 14:42:10'),
(182, 3, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 14:42:40', '2026-02-01 14:42:40'),
(183, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:42:51', '2026-02-01 14:42:51'),
(184, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:44:50', '2026-02-01 14:44:50'),
(185, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:45:57', '2026-02-01 14:45:57'),
(186, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:48:23', '2026-02-01 14:48:23'),
(187, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:50:36', '2026-02-01 14:50:36'),
(188, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 14:55:00', '2026-02-01 14:55:00'),
(189, 3, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 15:02:38', '2026-02-01 15:02:38'),
(190, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 15:02:48', '2026-02-01 15:02:48'),
(191, 3, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 15:02:57', '2026-02-01 15:02:57'),
(192, 2, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 15:03:08', '2026-02-01 15:03:08'),
(193, 2, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 15:03:11', '2026-02-01 15:03:11'),
(194, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 15:03:22', '2026-02-01 15:03:22'),
(195, 1, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 15:03:28', '2026-02-01 15:03:28'),
(196, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 21:14:56', '2026-02-01 21:14:56'),
(197, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 21:23:02', '2026-02-01 21:23:02'),
(198, 3, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 21:27:28', '2026-02-01 21:27:28'),
(199, 3, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 21:30:25', '2026-02-01 21:30:25'),
(200, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 21:31:00', '2026-02-01 21:31:00'),
(201, 3, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 21:31:04', '2026-02-01 21:31:04'),
(202, 3, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 21:33:06', '2026-02-01 21:33:06'),
(203, 3, 'Vente', 'Vente de 2 unités - Boisson ID: 4 - Montant: 7000', '2026-02-01 21:33:44', '2026-02-01 21:33:44'),
(204, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 21:36:09', '2026-02-01 21:36:09'),
(205, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 21:36:12', '2026-02-01 21:36:12'),
(206, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 21:36:34', '2026-02-01 21:36:34'),
(207, 3, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-01 21:38:02', '2026-02-01 21:38:02'),
(208, 3, 'Vente', 'Vente de 2 unités - Boisson ID: 4 - Montant: 7000', '2026-02-01 21:38:59', '2026-02-01 21:38:59'),
(209, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 21:39:09', '2026-02-01 21:39:09'),
(210, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 21:39:57', '2026-02-01 21:39:57'),
(211, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 21:47:15', '2026-02-01 21:47:15'),
(212, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 21:47:56', '2026-02-01 21:47:56'),
(213, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-01 22:01:36', '2026-02-01 22:01:36'),
(214, 3, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 22:02:16', '2026-02-01 22:02:16'),
(215, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 22:02:27', '2026-02-01 22:02:27'),
(216, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:02:39', '2026-02-01 22:02:39'),
(217, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:02:47', '2026-02-01 22:02:47'),
(218, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:03:58', '2026-02-01 22:03:58'),
(219, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:15:41', '2026-02-01 22:15:41'),
(220, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:15:48', '2026-02-01 22:15:48'),
(221, 3, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 22:15:54', '2026-02-01 22:15:54'),
(222, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 22:16:06', '2026-02-01 22:16:06'),
(223, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:16:10', '2026-02-01 22:16:10'),
(224, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:16:26', '2026-02-01 22:16:26'),
(225, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-01 22:20:30', '2026-02-01 22:20:30'),
(226, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-01 22:21:35', '2026-02-01 22:21:35'),
(227, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-01 22:21:55', '2026-02-01 22:21:55'),
(228, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:22:14', '2026-02-01 22:22:14'),
(229, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:22:19', '2026-02-01 22:22:19'),
(230, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:23:55', '2026-02-01 22:23:55'),
(231, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:27:41', '2026-02-01 22:27:41'),
(232, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:29:27', '2026-02-01 22:29:27'),
(233, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:33:06', '2026-02-01 22:33:06'),
(234, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:33:16', '2026-02-01 22:33:16'),
(235, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:33:19', '2026-02-01 22:33:19'),
(236, 3, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 22:33:27', '2026-02-01 22:33:27'),
(237, 2, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 22:33:51', '2026-02-01 22:33:51'),
(238, 2, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:33:54', '2026-02-01 22:33:54'),
(239, 2, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 22:34:50', '2026-02-01 22:34:50'),
(240, 2, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:34:53', '2026-02-01 22:34:53'),
(241, 2, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:35:18', '2026-02-01 22:35:18'),
(242, 2, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:35:46', '2026-02-01 22:35:46'),
(243, 2, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 22:35:51', '2026-02-01 22:35:51'),
(244, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 22:36:05', '2026-02-01 22:36:05'),
(245, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:36:08', '2026-02-01 22:36:08'),
(246, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 22:36:39', '2026-02-01 22:36:39'),
(247, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:36:43', '2026-02-01 22:36:43'),
(248, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 22:37:36', '2026-02-01 22:37:36'),
(249, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:37:37', '2026-02-01 22:37:37'),
(250, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 22:38:03', '2026-02-01 22:38:03'),
(251, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:38:05', '2026-02-01 22:38:05'),
(252, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 22:39:24', '2026-02-01 22:39:24'),
(253, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:39:25', '2026-02-01 22:39:25'),
(254, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:39:30', '2026-02-01 22:39:30'),
(255, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 22:42:54', '2026-02-01 22:42:54'),
(256, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-01 22:42:55', '2026-02-01 22:42:55'),
(257, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-01 22:45:10', '2026-02-01 22:45:10'),
(258, 1, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-01 22:45:15', '2026-02-01 22:45:15'),
(259, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-01 22:45:26', '2026-02-01 22:45:26'),
(260, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-01 22:45:29', '2026-02-01 22:45:29'),
(261, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-01 22:45:32', '2026-02-01 22:45:32'),
(262, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-02 14:44:01', '2026-02-02 14:44:01'),
(263, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 14:47:46', '2026-02-02 14:47:46'),
(264, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-02 14:47:49', '2026-02-02 14:47:49'),
(265, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-02 14:48:57', '2026-02-02 14:48:57'),
(266, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 14:49:00', '2026-02-02 14:49:00'),
(267, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 14:49:06', '2026-02-02 14:49:06'),
(268, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 14:49:58', '2026-02-02 14:49:58'),
(269, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 14:50:00', '2026-02-02 14:50:00'),
(270, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 14:50:02', '2026-02-02 14:50:02'),
(271, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-02 14:50:21', '2026-02-02 14:50:21'),
(272, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 14:50:23', '2026-02-02 14:50:23'),
(273, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 14:50:27', '2026-02-02 14:50:27'),
(274, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 14:50:29', '2026-02-02 14:50:29'),
(275, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 14:50:55', '2026-02-02 14:50:55'),
(276, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 14:50:56', '2026-02-02 14:50:56'),
(277, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-02 14:50:57', '2026-02-02 14:50:57'),
(278, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 14:50:59', '2026-02-02 14:50:59'),
(279, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-02 15:13:41', '2026-02-02 15:13:41'),
(280, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-02 15:17:25', '2026-02-02 15:17:25'),
(281, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-02 15:20:27', '2026-02-02 15:20:27'),
(282, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 15:20:29', '2026-02-02 15:20:29'),
(283, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 15:20:34', '2026-02-02 15:20:34'),
(284, 1, 'Consultation Utilisateurs', 'A consulté la liste des utilisateurs', '2026-02-02 15:20:41', '2026-02-02 15:20:41'),
(285, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-02 15:29:15', '2026-02-02 15:29:15'),
(286, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 15:29:16', '2026-02-02 15:29:16'),
(287, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 15:29:17', '2026-02-02 15:29:17'),
(288, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 15:29:22', '2026-02-02 15:29:22'),
(289, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 15:29:24', '2026-02-02 15:29:24'),
(290, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-02 15:34:05', '2026-02-02 15:34:05'),
(291, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 15:34:07', '2026-02-02 15:34:07'),
(292, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 15:34:09', '2026-02-02 15:34:09'),
(293, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 15:34:12', '2026-02-02 15:34:12'),
(294, 1, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-02 15:34:17', '2026-02-02 15:34:17'),
(295, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-02 15:34:32', '2026-02-02 15:34:32'),
(296, 3, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-02 15:34:49', '2026-02-02 15:34:49'),
(297, 3, 'Vente', 'Vente de 4 unités - Boisson ID: 3 - Montant: 20000', '2026-02-02 15:35:03', '2026-02-02 15:35:03'),
(298, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 15:35:10', '2026-02-02 15:35:10'),
(299, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 15:35:23', '2026-02-02 15:35:23'),
(300, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 15:35:27', '2026-02-02 15:35:27'),
(301, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 15:35:58', '2026-02-02 15:35:58'),
(302, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 15:35:59', '2026-02-02 15:35:59'),
(303, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 15:36:00', '2026-02-02 15:36:00'),
(304, 3, 'Déconnexion', 'Utilisateur déconnecté', '2026-02-02 15:36:22', '2026-02-02 15:36:22'),
(305, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-02 15:36:33', '2026-02-02 15:36:33'),
(306, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 15:36:35', '2026-02-02 15:36:35'),
(307, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 15:36:37', '2026-02-02 15:36:37'),
(308, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 15:36:40', '2026-02-02 15:36:40'),
(309, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 15:38:27', '2026-02-02 15:38:27'),
(310, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 15:38:37', '2026-02-02 15:38:37'),
(311, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 15:38:38', '2026-02-02 15:38:38'),
(312, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 15:38:46', '2026-02-02 15:38:46'),
(313, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-02 15:45:24', '2026-02-02 15:45:24'),
(314, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 15:45:27', '2026-02-02 15:45:27'),
(315, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 15:48:44', '2026-02-02 15:48:44'),
(316, 3, 'Clôture automatique', 'Clôture automatique du 2026-02-02 - Total: 20000 - 1 ventes', '2026-02-02 15:49:31', '2026-02-02 15:49:31'),
(317, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 15:49:37', '2026-02-02 15:49:37'),
(318, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 15:49:39', '2026-02-02 15:49:39'),
(319, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 15:50:41', '2026-02-02 15:50:41'),
(320, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 15:50:42', '2026-02-02 15:50:42'),
(321, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 15:51:17', '2026-02-02 15:51:17'),
(322, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-02 18:54:06', '2026-02-02 18:54:06'),
(323, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-02 18:54:09', '2026-02-02 18:54:09'),
(324, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-03 09:41:18', '2026-02-03 09:41:18'),
(325, 3, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-03 09:50:42', '2026-02-03 09:50:42'),
(326, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-03 09:50:57', '2026-02-03 09:50:57'),
(327, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-03 09:55:16', '2026-02-03 09:55:16'),
(328, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-03 09:55:28', '2026-02-03 09:55:28'),
(329, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-03 09:55:29', '2026-02-03 09:55:29'),
(330, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-03 09:55:40', '2026-02-03 09:55:40'),
(331, 3, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-03 09:56:13', '2026-02-03 09:56:13'),
(332, 3, 'Vente', 'Vente de 2 unités - Boisson ID: 5 - Montant: 24000', '2026-02-03 09:56:24', '2026-02-03 09:56:24'),
(333, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-03 09:56:32', '2026-02-03 09:56:32'),
(334, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-03 09:56:38', '2026-02-03 09:56:38'),
(335, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-03 09:57:10', '2026-02-03 09:57:10'),
(336, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-03 09:57:16', '2026-02-03 09:57:16'),
(337, 1, 'Consultation Types Boissons', 'A consulté la liste des types de boissons', '2026-02-03 09:57:31', '2026-02-03 09:57:31'),
(338, 1, 'Ajout Boisson', 'Ajout de la boisson: Vitalo pt', '2026-02-03 09:57:58', '2026-02-03 09:57:58'),
(339, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-03 09:58:07', '2026-02-03 09:58:07'),
(340, 1, 'Ajout Stock', 'Ajout de 20 unités pour la boisson ID: 6', '2026-02-03 09:58:16', '2026-02-03 09:58:16'),
(341, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-03 09:58:23', '2026-02-03 09:58:23'),
(342, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-03 09:58:39', '2026-02-03 09:58:39'),
(343, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-03 09:59:01', '2026-02-03 09:59:01'),
(344, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-03 10:06:20', '2026-02-03 10:06:20'),
(345, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-03 10:06:51', '2026-02-03 10:06:51'),
(346, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-03 10:06:59', '2026-02-03 10:06:59'),
(347, 3, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-03 10:07:03', '2026-02-03 10:07:03'),
(348, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-03 10:07:21', '2026-02-03 10:07:21'),
(349, 1, 'Consultation Types Boissons', 'A consulté la liste des types de boissons', '2026-02-03 10:07:24', '2026-02-03 10:07:24'),
(350, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-03 10:08:25', '2026-02-03 10:08:25'),
(351, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-03 10:08:27', '2026-02-03 10:08:27'),
(352, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-03 11:43:53', '2026-02-03 11:43:53'),
(353, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-03 11:43:54', '2026-02-03 11:43:54'),
(354, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-03 11:44:09', '2026-02-03 11:44:09'),
(355, 1, 'Consultation Types Boissons', 'A consulté la liste des types de boissons', '2026-02-03 11:44:15', '2026-02-03 11:44:15'),
(356, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-03 11:44:38', '2026-02-03 11:44:38'),
(357, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-03 11:47:09', '2026-02-03 11:47:09'),
(358, 1, 'Consultation Types Boissons', 'A consulté la liste des types de boissons', '2026-02-03 11:51:35', '2026-02-03 11:51:35'),
(359, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-03 11:52:13', '2026-02-03 11:52:13'),
(360, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-03 11:52:15', '2026-02-03 11:52:15'),
(361, 3, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-03 11:52:50', '2026-02-03 11:52:50'),
(362, 1, 'Connexion', 'Utilisateur connecté avec succès', '2026-02-03 12:03:45', '2026-02-03 12:03:45'),
(363, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-03 12:03:51', '2026-02-03 12:03:51'),
(364, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-03 12:03:55', '2026-02-03 12:03:55'),
(365, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-03 12:03:57', '2026-02-03 12:03:57'),
(366, 1, 'Consultation Utilisateurs', 'A consulté la liste des utilisateurs', '2026-02-03 12:04:02', '2026-02-03 12:04:02'),
(367, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-03 12:36:28', '2026-02-03 12:36:28'),
(368, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-03 12:36:29', '2026-02-03 12:36:29'),
(369, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-03 12:36:33', '2026-02-03 12:36:33'),
(370, 1, 'Consultation Utilisateurs', 'A consulté la liste des utilisateurs', '2026-02-03 12:36:40', '2026-02-03 12:36:40'),
(371, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-03 12:36:53', '2026-02-03 12:36:53'),
(372, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-03 12:36:57', '2026-02-03 12:36:57'),
(373, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-03 12:37:00', '2026-02-03 12:37:00'),
(374, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-03 12:37:04', '2026-02-03 12:37:04'),
(375, 1, 'Consultation Vente', 'A consulté la liste de vente', '2026-02-03 12:37:07', '2026-02-03 12:37:07'),
(376, 1, 'Consultation Cloture', 'A consulté la liste de cloture', '2026-02-03 12:37:10', '2026-02-03 12:37:10'),
(377, 1, 'Consultation Stock', 'A consulté la liste des stocks', '2026-02-03 12:37:11', '2026-02-03 12:37:11'),
(378, 1, 'Consultation Types Boissons', 'A consulté la liste des types de boissons', '2026-02-03 12:37:13', '2026-02-03 12:37:13'),
(379, 1, 'Consultation Boissons', 'A consulté la liste des boissons', '2026-02-03 12:37:15', '2026-02-03 12:37:15');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_00_31_0000_create_roles_table', 1),
(2, '0001_01_01_000000_create_users_table', 1),
(3, '0001_01_01_000001_create_cache_table', 1),
(4, '0001_01_01_000002_create_jobs_table', 1),
(5, '2026_01_31_092715_create_type_boissons_table', 1),
(6, '2026_01_31_092734_create_boissons_table', 1),
(7, '2026_01_31_092755_create_stocks_table', 1),
(8, '2026_01_31_092813_create_ventes_table', 1),
(9, '2026_01_31_092834_create_clotures_table', 1),
(10, '2026_01_31_092857_create_cloture_details_table', 1),
(11, '2026_01_31_092915_create_historiques_table', 1),
(12, '2026_01_31_105550_create_personal_access_tokens_table', 2);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(4, 'App\\Models\\User', 1, 'auth_token', '9649413699c4506520bd5ec560cb0426c9f3e893605cbe3e27dd7762dbb07793', '[\"*\"]', NULL, NULL, '2026-01-31 12:13:26', '2026-01-31 12:13:26'),
(5, 'App\\Models\\User', 1, 'auth_token', 'bd1b87060194c974b0908b3bbc6031319b05f9e676b5edc810a8d3a3722d7ba3', '[\"*\"]', NULL, NULL, '2026-01-31 12:14:28', '2026-01-31 12:14:28'),
(6, 'App\\Models\\User', 1, 'auth_token', '5dad66362c75638ed92c14736ce6de798588a73ace67cd1b256c0c4122fb0d7f', '[\"*\"]', NULL, NULL, '2026-01-31 12:17:36', '2026-01-31 12:17:36'),
(7, 'App\\Models\\User', 1, 'auth_token', '95d7b27d164a17e723368cc9137e5fbe89fb8c9760c025edb35a8e08ff7de6ab', '[\"*\"]', NULL, NULL, '2026-01-31 12:17:38', '2026-01-31 12:17:38'),
(8, 'App\\Models\\User', 1, 'auth_token', '8314c27f7c7a9ed39ef0f47b44c721571a05beac03fc7aa0aa20d3e08eb1d272', '[\"*\"]', NULL, NULL, '2026-01-31 12:18:02', '2026-01-31 12:18:02'),
(9, 'App\\Models\\User', 1, 'auth_token', '3f32b1181afabe0be112f03213a01999a1e0438b4958f2844fd955327326f159', '[\"*\"]', NULL, NULL, '2026-01-31 12:18:12', '2026-01-31 12:18:12'),
(10, 'App\\Models\\User', 1, 'auth_token', 'cc0db43f23837b407f17db9371b7427d445b27a5cbc5688bab2e7b6471990c3f', '[\"*\"]', NULL, NULL, '2026-01-31 12:19:08', '2026-01-31 12:19:08'),
(11, 'App\\Models\\User', 1, 'auth_token', '84cf1e52021b7bfc512bb0e60c6ce0787ba215b479724243599785c24f3b21f2', '[\"*\"]', NULL, NULL, '2026-01-31 12:19:50', '2026-01-31 12:19:50'),
(12, 'App\\Models\\User', 1, 'auth_token', '1c8e662dbd416cfda5452e407782b88cb2b7cf5b97ce4bb64f6605bca2d816c2', '[\"*\"]', NULL, NULL, '2026-01-31 12:19:59', '2026-01-31 12:19:59'),
(13, 'App\\Models\\User', 1, 'auth_token', '6428657a1d0069078e3375765ed462945806da9f934ac3357779071f1f3c48af', '[\"*\"]', NULL, NULL, '2026-01-31 12:20:00', '2026-01-31 12:20:00'),
(14, 'App\\Models\\User', 1, 'auth_token', 'c8e25b90ef4c852313935ccab318dcedac648c26f1328e01d76094c853967bb9', '[\"*\"]', NULL, NULL, '2026-01-31 12:20:11', '2026-01-31 12:20:11'),
(15, 'App\\Models\\User', 1, 'auth_token', '9e2c01a669acf827641a304f424a6edbc930d73b2d2edce79eea1af70a6dfb81', '[\"*\"]', NULL, NULL, '2026-01-31 12:20:36', '2026-01-31 12:20:36'),
(16, 'App\\Models\\User', 1, 'auth_token', '5ae8d595e1c94d41c3f6c0b29c7445477dacf94b66099942013b2235c310409b', '[\"*\"]', NULL, NULL, '2026-01-31 12:20:40', '2026-01-31 12:20:40'),
(17, 'App\\Models\\User', 1, 'auth_token', 'd5a58d83bd66ddc6429329c8ebc6cde93b538639092e8bb70c78b40124198810', '[\"*\"]', NULL, NULL, '2026-01-31 12:21:43', '2026-01-31 12:21:43'),
(18, 'App\\Models\\User', 1, 'auth_token', '88131d08ba52f6d0450e2aedcc7c5f36c2d71ff49aa816fc4b25a6784cec50c6', '[\"*\"]', NULL, NULL, '2026-01-31 12:21:45', '2026-01-31 12:21:45'),
(19, 'App\\Models\\User', 1, 'auth_token', 'c983ce42cb6efa6e66dc0230c5dcc5c590de06677baefd4419ce79ef35a6ee61', '[\"*\"]', NULL, NULL, '2026-01-31 12:22:00', '2026-01-31 12:22:00'),
(20, 'App\\Models\\User', 1, 'auth_token', 'cce043b2c7f86d40e82748953b4d299061cd5d65d504cf477fdd090f7bf34482', '[\"*\"]', NULL, NULL, '2026-01-31 12:22:09', '2026-01-31 12:22:09'),
(21, 'App\\Models\\User', 1, 'auth_token', '12b4b79d08d2f2567f5dd54ddc4899bf0ae971c4007795ed7d0a9b23c0ba0c94', '[\"*\"]', NULL, NULL, '2026-01-31 12:22:10', '2026-01-31 12:22:10'),
(22, 'App\\Models\\User', 1, 'auth_token', '47a4aca360702bac5add500d5a70bd8e412c76814a7e5db585e6fbe0547f512c', '[\"*\"]', NULL, NULL, '2026-01-31 12:22:12', '2026-01-31 12:22:12'),
(23, 'App\\Models\\User', 1, 'auth_token', 'efd5214c08ac2b77069b660b0010bbc7093d4e12d8c649160bcc78b17078c956', '[\"*\"]', NULL, NULL, '2026-01-31 12:22:25', '2026-01-31 12:22:25'),
(24, 'App\\Models\\User', 1, 'auth_token', '9a93c0db7987742507c526a5d3d897932228e4e2b861b2acdf0e429d181b91e1', '[\"*\"]', NULL, NULL, '2026-01-31 12:22:39', '2026-01-31 12:22:39'),
(25, 'App\\Models\\User', 1, 'auth_token', 'e4741b3f464d5ba03b672ace45c6b798755c035d79f3e206213d891ee9efda08', '[\"*\"]', NULL, NULL, '2026-01-31 12:23:26', '2026-01-31 12:23:26'),
(26, 'App\\Models\\User', 1, 'auth_token', '3cbf283b2aff59469f2bab82421808a13aacc846d957d59a01eb787aa2c1ca16', '[\"*\"]', NULL, NULL, '2026-01-31 12:23:27', '2026-01-31 12:23:27'),
(27, 'App\\Models\\User', 1, 'auth_token', '09149233eb22dd1577e58b0c8d0e1af0ab0e44998312c70bb3c258f231711b2e', '[\"*\"]', NULL, NULL, '2026-01-31 12:23:37', '2026-01-31 12:23:37'),
(28, 'App\\Models\\User', 1, 'auth_token', '6aeb32fe1c1da3328f23006c14cac2152cf45d0c389f3f09fee3ecb4e1283f45', '[\"*\"]', NULL, NULL, '2026-01-31 12:23:38', '2026-01-31 12:23:38'),
(29, 'App\\Models\\User', 1, 'auth_token', '2eb5b4a9e6c946041c4a97936ba90d0cdd13537835d9ecd5e2bc3b7943f821af', '[\"*\"]', NULL, NULL, '2026-01-31 12:23:49', '2026-01-31 12:23:49'),
(30, 'App\\Models\\User', 1, 'auth_token', '94fc3c0c9403475feb37bf4b83d19a11a3a780c8d05920e5bde1035f1e9540eb', '[\"*\"]', NULL, NULL, '2026-01-31 12:25:05', '2026-01-31 12:25:05'),
(31, 'App\\Models\\User', 1, 'auth_token', 'beb2a0560e6ff2de3b387051517349e2c859562c70a054431225cf4c8ee28227', '[\"*\"]', NULL, NULL, '2026-01-31 12:25:06', '2026-01-31 12:25:06'),
(32, 'App\\Models\\User', 1, 'auth_token', '2b52321127eec7a01aa35f46cd679efb395315d524782aea8564b21657f6614b', '[\"*\"]', NULL, NULL, '2026-01-31 12:25:16', '2026-01-31 12:25:16'),
(33, 'App\\Models\\User', 1, 'auth_token', '7aa4b907fe08c2acf84e0540d76829569edcc5438b222dd4541705c696cb759a', '[\"*\"]', NULL, NULL, '2026-01-31 12:25:18', '2026-01-31 12:25:18'),
(34, 'App\\Models\\User', 1, 'auth_token', '99108f06aa849a5dfbbe7fd55d50952a0e8180688ee2d3284e8df7833a556af9', '[\"*\"]', NULL, NULL, '2026-01-31 12:35:12', '2026-01-31 12:35:12'),
(35, 'App\\Models\\User', 1, 'auth_token', '3c1770445c2c5b8b5078106b7052b0161d05b917f9cd0dd79a663a322dfe8eb4', '[\"*\"]', NULL, NULL, '2026-01-31 12:35:14', '2026-01-31 12:35:14'),
(36, 'App\\Models\\User', 1, 'auth_token', 'c82e30715a70b35343aae2bf6bf1da12ca69091a18ad05938f37d1676823fdd8', '[\"*\"]', NULL, NULL, '2026-01-31 12:36:13', '2026-01-31 12:36:13'),
(37, 'App\\Models\\User', 1, 'auth_token', '27f9d7d479274f3b71722bf47cfb16b9d9faeb91eb179d178c49972f6aae8902', '[\"*\"]', NULL, NULL, '2026-01-31 12:37:00', '2026-01-31 12:37:00'),
(38, 'App\\Models\\User', 1, 'auth_token', '1a87b923d93656ded5d2fce5bc2434e63744126a6c8a78d5bb621698072ad53e', '[\"*\"]', NULL, NULL, '2026-01-31 12:37:15', '2026-01-31 12:37:15'),
(39, 'App\\Models\\User', 1, 'auth_token', '80ca0a09027e9a9a1e690dcf649122456385a16893cc669dbe1a13977ccb9609', '[\"*\"]', NULL, NULL, '2026-01-31 12:38:07', '2026-01-31 12:38:07'),
(40, 'App\\Models\\User', 1, 'auth_token', '9ab05057b2b44d93e7265e6ce3b1b0664eb90a265c1f73619fa395edffb7ef02', '[\"*\"]', NULL, NULL, '2026-01-31 12:48:00', '2026-01-31 12:48:00'),
(41, 'App\\Models\\User', 1, 'auth_token', '2f6e10434d2570444c1cf57be7a47b704370f3ec75c57fd20f7347527b5b9cb8', '[\"*\"]', NULL, NULL, '2026-01-31 12:48:29', '2026-01-31 12:48:29'),
(42, 'App\\Models\\User', 1, 'auth_token', '6913532ee78e236aa69ebe2bed6fce2e780e63ae34d0a399c16a42ad7583f641', '[\"*\"]', NULL, NULL, '2026-01-31 12:48:53', '2026-01-31 12:48:53'),
(43, 'App\\Models\\User', 1, 'auth_token', 'bae73217a4ac0f3e9cb0765d61e834817fe7c2496e2fe565e1a4d49976bac5f5', '[\"*\"]', NULL, NULL, '2026-01-31 12:50:36', '2026-01-31 12:50:36'),
(44, 'App\\Models\\User', 1, 'auth_token', '3fa393d3a16322d9233ad9c35ee2121fa36da564d28eff20dabcd794cb11e5fd', '[\"*\"]', NULL, NULL, '2026-01-31 12:50:52', '2026-01-31 12:50:52'),
(45, 'App\\Models\\User', 1, 'auth_token', 'ff3b8adbb4fdb2ce92ac08c4f4398f4cc1bb39f620c8d212a1bad27b5f6297c9', '[\"*\"]', NULL, NULL, '2026-01-31 12:52:15', '2026-01-31 12:52:15'),
(46, 'App\\Models\\User', 1, 'auth_token', '85badf60e61de2116b04750029740d97480ef30ea57fe49fbe3f01ce1ba81a72', '[\"*\"]', NULL, NULL, '2026-01-31 12:52:16', '2026-01-31 12:52:16'),
(47, 'App\\Models\\User', 1, 'auth_token', '64381cf8110a3e9ae136e5836b69f36cae2c5001d1ebff9d6e47b9c87a8e379e', '[\"*\"]', NULL, NULL, '2026-01-31 12:54:45', '2026-01-31 12:54:45'),
(48, 'App\\Models\\User', 1, 'auth_token', 'e00395079b2e035c71f953df2ee76c1ab09e237c8d1261908549dfed6b754bc7', '[\"*\"]', NULL, NULL, '2026-01-31 12:56:01', '2026-01-31 12:56:01'),
(49, 'App\\Models\\User', 1, 'auth_token', 'd07f0fb09e42b9d5f5b697bff93596be082ef42490d8d8dbd38b4f374c2bc97a', '[\"*\"]', '2026-02-01 11:37:37', NULL, '2026-01-31 12:56:02', '2026-02-01 11:37:37'),
(50, 'App\\Models\\User', 1, 'auth_token', 'a2190ef87f68963cfb95281f97a2626be687080f56ce47bdb073a165ff4e666f', '[\"*\"]', '2026-01-31 14:38:17', NULL, '2026-01-31 14:31:22', '2026-01-31 14:38:17'),
(51, 'App\\Models\\User', 1, 'auth_token', '31badd54d9e8620a618ad0123a8d8f97dbeae3594206f52750bbe1d4bc079585', '[\"*\"]', '2026-01-31 15:23:28', NULL, '2026-01-31 14:38:40', '2026-01-31 15:23:28'),
(52, 'App\\Models\\User', 1, 'auth_token', '64c1e7c4d7c8bad0c70e750bd49ae9cafbcd3c82097c2d409e86caa454baf584', '[\"*\"]', '2026-01-31 15:25:07', NULL, '2026-01-31 15:23:58', '2026-01-31 15:25:07'),
(53, 'App\\Models\\User', 1, 'auth_token', 'caa211765d876b219f8940f3dbc5707c41d2e02ac72ffc04d8c278251b07ed31', '[\"*\"]', '2026-01-31 16:12:51', NULL, '2026-01-31 15:27:09', '2026-01-31 16:12:51'),
(54, 'App\\Models\\User', 1, 'auth_token', '2276cdd2f6961759bb7a8b74e3e932a371c3c3f28ce50f0533d6e233ed5bc797', '[\"*\"]', '2026-01-31 18:45:02', NULL, '2026-01-31 16:13:23', '2026-01-31 18:45:02'),
(55, 'App\\Models\\User', 1, 'auth_token', 'eaeb95eaa212abfd4310f54cd155a10a2cc496be1c77aace82f5fc5a97084791', '[\"*\"]', '2026-02-01 11:32:54', NULL, '2026-02-01 09:57:35', '2026-02-01 11:32:54'),
(56, 'App\\Models\\User', 1, 'auth_token', 'af5fa3305880e11dc643c7062a899082e758e205973009600a3d483a9f8d383d', '[\"*\"]', '2026-02-01 12:17:12', NULL, '2026-02-01 11:34:13', '2026-02-01 12:17:12'),
(57, 'App\\Models\\User', 1, 'auth_token', '2eceb669687e5a3a7c1bd87151b2175621e148b095d7cbc94685922acd105514', '[\"*\"]', '2026-02-01 11:38:34', NULL, '2026-02-01 11:38:02', '2026-02-01 11:38:34'),
(58, 'App\\Models\\User', 1, 'auth_token', '4e70d41bd66e43c5c993787e419e2925d073c99b28d0d4805056c5ac809a0f15', '[\"*\"]', '2026-02-01 13:41:12', NULL, '2026-02-01 12:42:00', '2026-02-01 13:41:12'),
(60, 'App\\Models\\User', 2, 'auth_token', '99eb6110b1633aedf8e371c8c1cd939d3cd8732259494b44891e9cf842145d2f', '[\"*\"]', '2026-02-01 14:12:19', NULL, '2026-02-01 14:11:23', '2026-02-01 14:12:19'),
(63, 'App\\Models\\User', 1, 'auth_token', 'e7738a555653987447d7c3cdeac61feb935b85d427d1ab029df82569d9961bce', '[\"*\"]', '2026-02-01 14:15:57', NULL, '2026-02-01 14:15:57', '2026-02-01 14:15:57'),
(64, 'App\\Models\\User', 1, 'auth_token', 'ac51ca3aa08511c315b42499ea20a0795cecf7d408477385637169a3be3d125f', '[\"*\"]', '2026-02-01 14:16:50', NULL, '2026-02-01 14:16:50', '2026-02-01 14:16:50'),
(65, 'App\\Models\\User', 1, 'auth_token', 'ef4b083637b1feb4d2b9e4bc8b89652f99659f10b3bc1e68611010fbc02312d3', '[\"*\"]', '2026-02-01 14:18:14', NULL, '2026-02-01 14:18:04', '2026-02-01 14:18:14'),
(67, 'App\\Models\\User', 2, 'auth_token', '9b066f56c5722d7c873e9c3797a0bf6227547b7c0397795c01a312ebf9abbbfe', '[\"*\"]', '2026-02-01 14:23:57', NULL, '2026-02-01 14:22:08', '2026-02-01 14:23:57'),
(74, 'App\\Models\\User', 2, 'auth_token', 'a850b69fcb07d3c9271fba742f059e35cb4a0f17927ec8e8d03a0bad7288430d', '[\"*\"]', '2026-02-01 14:37:25', NULL, '2026-02-01 14:37:24', '2026-02-01 14:37:25'),
(79, 'App\\Models\\User', 1, 'auth_token', 'fb3835da35783e6acfa8b81529bcfab4058932941778a813cdc38198405c3af3', '[\"*\"]', NULL, NULL, '2026-02-01 14:42:10', '2026-02-01 14:42:10'),
(80, 'App\\Models\\User', 3, 'auth_token', '7b5d2e28b4979fea16050732fa870882a85b45b8a076e6abb6ef2b013ea76dda', '[\"*\"]', '2026-02-01 14:42:59', NULL, '2026-02-01 14:42:51', '2026-02-01 14:42:59'),
(81, 'App\\Models\\User', 3, 'auth_token', 'a0d62d52cfb50c3f6e27653d36fb0dd3aa637c47d9151a32d8b848493f2fb644', '[\"*\"]', '2026-02-01 14:44:50', NULL, '2026-02-01 14:44:50', '2026-02-01 14:44:50'),
(82, 'App\\Models\\User', 3, 'auth_token', '26170eddca5b296ab3ea3acbbdd425ae9c7bb2cfddce79a8368d17f095bd8331', '[\"*\"]', '2026-02-01 14:45:57', NULL, '2026-02-01 14:45:57', '2026-02-01 14:45:57'),
(83, 'App\\Models\\User', 3, 'auth_token', '8688cc592881c92479b0fa8a8c01239c68d52ee006ca270c947e2c8113d9907d', '[\"*\"]', '2026-02-01 14:48:23', NULL, '2026-02-01 14:48:23', '2026-02-01 14:48:23'),
(84, 'App\\Models\\User', 3, 'auth_token', 'e02ea0db972772af57d671d38739bc39533690e578df7e85d0e8fd20647733a0', '[\"*\"]', '2026-02-01 14:50:36', NULL, '2026-02-01 14:50:36', '2026-02-01 14:50:36'),
(90, 'App\\Models\\User', 1, 'auth_token', '7d2aaa50b9bec7cf53f1048c9ba45039078e8c599316c670ba0fc8607b7532eb', '[\"*\"]', '2026-02-01 22:21:35', NULL, '2026-02-01 21:47:15', '2026-02-01 22:21:35'),
(95, 'App\\Models\\User', 3, 'auth_token', 'e99039ac1e41fb21fa2eba24238926b9a5474bb0fe222ec8be566450ca703c14', '[\"*\"]', '2026-02-01 22:45:38', NULL, '2026-02-01 22:45:26', '2026-02-01 22:45:38'),
(96, 'App\\Models\\User', 1, 'auth_token', '14e57edf3efa35b867f8037c11b469bd3ac211b779965d4c3fdf763f0aebeecd', '[\"*\"]', '2026-02-02 14:47:50', NULL, '2026-02-02 14:44:01', '2026-02-02 14:47:50'),
(97, 'App\\Models\\User', 1, 'auth_token', 'e7d91bd4c0d0e464695969576f43122e99858b36cf4d15c700f52a2037122843', '[\"*\"]', '2026-02-02 14:50:01', NULL, '2026-02-02 14:48:57', '2026-02-02 14:50:01'),
(98, 'App\\Models\\User', 1, 'auth_token', '34aca32534b0a770175b1f130b5f3a35221f479b580c9027a92218afbfe5a0d8', '[\"*\"]', '2026-02-02 14:51:06', NULL, '2026-02-02 14:50:21', '2026-02-02 14:51:06'),
(99, 'App\\Models\\User', 1, 'auth_token', '691676f7fe0b65be7e6f996298718087a78685dd0199669e4b961a34ac3d9753', '[\"*\"]', '2026-02-02 15:16:20', NULL, '2026-02-02 15:13:41', '2026-02-02 15:16:20'),
(102, 'App\\Models\\User', 3, 'auth_token', '3e42ba99a9227a46d904611be6a1ba1a3f30db7a7f846580a64baa661ba695fd', '[\"*\"]', '2026-02-02 15:40:57', NULL, '2026-02-02 15:36:33', '2026-02-02 15:40:57'),
(103, 'App\\Models\\User', 3, 'auth_token', '538175f95144f73bc6e4723437f054c3047c5128c24066bfcd4fad5cde516cd5', '[\"*\"]', '2026-02-02 18:54:09', NULL, '2026-02-02 15:45:24', '2026-02-02 18:54:09'),
(104, 'App\\Models\\User', 3, 'auth_token', '004db0a390101b15f4667d58d8970aaba930ab3b92655f418022d5b1683e10ba', '[\"*\"]', '2026-02-03 09:41:33', NULL, '2026-02-03 09:41:18', '2026-02-03 09:41:33'),
(105, 'App\\Models\\User', 3, 'auth_token', '0ddb369f8f0176afcb7eaeb627f632c6d059f70fbc34c0eea7ef235c30be6390', '[\"*\"]', '2026-02-03 11:52:50', NULL, '2026-02-03 09:50:42', '2026-02-03 11:52:50'),
(106, 'App\\Models\\User', 1, 'auth_token', '7a2d997aef661a3ca41004c0e76df1cdc902d958687e32f9edc7fec66aa58662', '[\"*\"]', '2026-02-03 10:07:24', NULL, '2026-02-03 09:50:57', '2026-02-03 10:07:24'),
(107, 'App\\Models\\User', 1, 'auth_token', 'c0fc7cb49c5c112012733722ab8efb213751cb124edc12e060ed43b33e07936b', '[\"*\"]', '2026-02-03 11:52:57', NULL, '2026-02-03 10:08:25', '2026-02-03 11:52:57'),
(108, 'App\\Models\\User', 1, 'auth_token', 'd4b76ccf4562f7026bf920b34bb93ff84aeaa22688739008863096ab731f1dce', '[\"*\"]', '2026-02-03 12:37:19', NULL, '2026-02-03 12:03:45', '2026-02-03 12:37:19');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nom` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `nom`, `created_at`, `updated_at`) VALUES
(1, 'administrateur', '2026-01-31 11:04:45', '2026-01-31 11:04:45'),
(2, 'gerant', '2026-01-31 11:04:45', '2026-01-31 11:04:45'),
(3, 'vendeur', '2026-02-01 14:50:14', '2026-02-01 14:50:14');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('hEs8SrYWPbiTzWPRxwyN8omM70LqgVECsdatDz0u', NULL, '127.0.0.1', 'PostmanRuntime/7.51.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiSGZPc0hvYnpVZWdSeTRFbjRkQjQ2UEVLamloamNyVUN6RmtsZ0lrUCI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1769861417),
('SBBKqMjAncaeN6SpLZgb12BTI6W6CglaDwVx2sXY', NULL, '127.0.0.1', 'PostmanRuntime/7.51.1', 'YTozOntzOjY6Il90b2tlbiI7czo0MDoiWmE3UFhxdk93SXZLY3ltYmVkU2FYWjJhVm5pbjdseFZ6Z2NMZlg1cyI7czo5OiJfcHJldmlvdXMiO2E6Mjp7czozOiJ1cmwiO3M6MjE6Imh0dHA6Ly8xMjcuMC4wLjE6ODAwMCI7czo1OiJyb3V0ZSI7Tjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319fQ==', 1769872095);

-- --------------------------------------------------------

--
-- Table structure for table `stocks`
--

CREATE TABLE `stocks` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `boisson_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `quantite_initiale` int(11) NOT NULL,
  `quantite_actuelle` int(11) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `stocks`
--

INSERT INTO `stocks` (`id`, `boisson_id`, `user_id`, `quantite_initiale`, `quantite_actuelle`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 10, 7, '2026-01-31 14:03:38', '2026-01-31 14:15:34'),
(2, 2, 1, 10, 10, '2026-01-31 14:08:39', '2026-01-31 14:08:39'),
(3, 3, 1, 16, 12, '2026-02-01 11:50:05', '2026-02-02 15:35:03'),
(4, 4, 1, 20, 16, '2026-02-01 11:51:23', '2026-02-01 21:38:59'),
(5, 5, 1, 5, 3, '2026-02-01 12:14:05', '2026-02-03 09:56:24'),
(6, 6, 1, 20, 20, '2026-02-03 09:58:16', '2026-02-03 09:58:16');

-- --------------------------------------------------------

--
-- Table structure for table `type_boissons`
--

CREATE TABLE `type_boissons` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `type` varchar(50) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `type_boissons`
--

INSERT INTO `type_boissons` (`id`, `type`, `created_at`, `updated_at`) VALUES
(1, 'sucre', '2026-01-31 15:01:09', '2026-01-31 15:01:09'),
(2, 'biere', '2026-01-31 15:01:09', '2026-01-31 15:01:09'),
(3, 'whisky', '2026-02-01 12:10:19', '2026-02-01 12:10:19');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nom` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role_id` bigint(20) UNSIGNED NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nom`, `email`, `password`, `role_id`, `is_active`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'jonathan', 'jnthnkabongo@gmail.com', '$2y$12$HmnuCkrWIWYkVoiJvpiXEuhB1z0jots.rTaw21derJFoz8iJ5zvNK', 1, 1, NULL, '2026-01-31 11:06:23', '2026-01-31 11:06:23'),
(2, 'tabby kikwele', 'rabby@gmail.com', '$2y$12$lTMCdijXaSyaC86wgfJre.kfkKOn8yXGZ2iAEVIgydzzagCaP/3da', 2, 1, NULL, '2026-01-31 15:56:38', '2026-01-31 15:56:38'),
(3, 'chido tshimanga kalonji', 'chido@gmail.com', '$2y$12$eR9Ad2zqltdtWHdLxdLbfujRKC7bjjoYoZG8nfVbmTTDFAhEzD.5C', 3, 1, NULL, '2026-02-01 14:39:53', '2026-02-01 14:39:53');

-- --------------------------------------------------------

--
-- Table structure for table `ventes`
--

CREATE TABLE `ventes` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `boisson_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `quantite` int(11) NOT NULL,
  `prix` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ventes`
--

INSERT INTO `ventes` (`id`, `boisson_id`, `user_id`, `quantite`, `prix`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 3, 2.50, '2026-01-31 14:15:34', '2026-01-31 14:15:34'),
(2, 4, 3, 2, 3500.00, '2026-02-01 21:33:44', '2026-02-01 21:33:44'),
(3, 4, 3, 2, 3500.00, '2026-02-01 21:38:59', '2026-02-01 21:38:59'),
(4, 3, 3, 4, 5000.00, '2026-02-02 15:35:03', '2026-02-02 15:35:03'),
(5, 5, 3, 2, 12000.00, '2026-02-03 09:56:24', '2026-02-03 09:56:24');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `boissons`
--
ALTER TABLE `boissons`
  ADD PRIMARY KEY (`id`),
  ADD KEY `boissons_type_boisson_id_foreign` (`type_boisson_id`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `clotures`
--
ALTER TABLE `clotures`
  ADD PRIMARY KEY (`id`),
  ADD KEY `clotures_user_id_foreign` (`user_id`);

--
-- Indexes for table `cloture_details`
--
ALTER TABLE `cloture_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `cloture_details_cloture_id_foreign` (`cloture_id`),
  ADD KEY `cloture_details_boisson_id_foreign` (`boisson_id`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `historiques`
--
ALTER TABLE `historiques`
  ADD PRIMARY KEY (`id`),
  ADD KEY `historiques_user_id_foreign` (`user_id`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `roles_nom_unique` (`nom`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `stocks`
--
ALTER TABLE `stocks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stocks_boisson_id_foreign` (`boisson_id`),
  ADD KEY `stocks_user_id_foreign` (`user_id`);

--
-- Indexes for table `type_boissons`
--
ALTER TABLE `type_boissons`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `type_boissons_type_unique` (`type`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_role_id_foreign` (`role_id`);

--
-- Indexes for table `ventes`
--
ALTER TABLE `ventes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ventes_boisson_id_foreign` (`boisson_id`),
  ADD KEY `ventes_user_id_foreign` (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `boissons`
--
ALTER TABLE `boissons`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `clotures`
--
ALTER TABLE `clotures`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `cloture_details`
--
ALTER TABLE `cloture_details`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `historiques`
--
ALTER TABLE `historiques`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=380;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `stocks`
--
ALTER TABLE `stocks`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `type_boissons`
--
ALTER TABLE `type_boissons`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `ventes`
--
ALTER TABLE `ventes`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `boissons`
--
ALTER TABLE `boissons`
  ADD CONSTRAINT `boissons_type_boisson_id_foreign` FOREIGN KEY (`type_boisson_id`) REFERENCES `type_boissons` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `clotures`
--
ALTER TABLE `clotures`
  ADD CONSTRAINT `clotures_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `cloture_details`
--
ALTER TABLE `cloture_details`
  ADD CONSTRAINT `cloture_details_boisson_id_foreign` FOREIGN KEY (`boisson_id`) REFERENCES `boissons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `cloture_details_cloture_id_foreign` FOREIGN KEY (`cloture_id`) REFERENCES `clotures` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `historiques`
--
ALTER TABLE `historiques`
  ADD CONSTRAINT `historiques_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `stocks`
--
ALTER TABLE `stocks`
  ADD CONSTRAINT `stocks_boisson_id_foreign` FOREIGN KEY (`boisson_id`) REFERENCES `boissons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `stocks_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `ventes`
--
ALTER TABLE `ventes`
  ADD CONSTRAINT `ventes_boisson_id_foreign` FOREIGN KEY (`boisson_id`) REFERENCES `boissons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ventes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
