-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 08, 2026 at 05:48 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `honkai_star_retail_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `resources`
--

CREATE TABLE `resources` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `type` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `stock` int(11) DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL,
  `price` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `resources`
--

INSERT INTO `resources` (`id`, `name`, `type`, `description`, `stock`, `image`, `price`, `created_at`) VALUES
(1, 'Energy Drink', 'consumable', 'Restores energy quickly', 45, 'soda 1-Photoroom.png', 10, '2026-05-12 07:57:32'),
(2, 'Stellar Jade x160', 'In-Game Item', 'Mata uang premium Honkai: Star Rail. Digunakan untuk melakukan 1x pull di Warp banner.', 49, 'StellarJade.png', 3, '2026-06-08 15:13:23'),
(3, 'Stellar Jade x1600', 'In-Game Item', 'Paket hemat Stellar Jade untuk 10x pull sekaligus. Cocok untuk kejarin banner limited!', 29, 'StellarJade.png', 28, '2026-06-08 15:13:23'),
(4, 'Trailblaze Power Refill', 'In-Game Item', 'Isi ulang 60 Trailblaze Power untuk farming material dan relic. Max 6x per hari.', 80, 'TrailblazePowerRefill.png', 2, '2026-06-08 15:13:23'),
(5, 'Undying Ember x50', 'In-Game Item', 'Mata uang event yang bisa ditukar koleksi eksklusif di Merit Shop.', 60, 'UndyingEmbers.png', 5, '2026-06-08 15:13:23'),
(6, 'Relic Remains Pack', 'In-Game Item', 'Berisi 5 Relic Remains untuk crafting relic pilihan di Artisan of Destruction.', 40, 'RelicRemain.png', 10, '2026-06-08 15:13:23'),
(7, 'Star Rail Pass x10', 'In-Game Item', 'Tiket gacha standar untuk Departure Warp dan Standard Banner. Langsung masuk ke akun.', 25, 'StarRailPass.png', 15, '2026-06-08 15:13:23'),
(8, 'Star Rail Special Pass x10', 'In-Game Item', 'Tiket gacha eksklusif untuk Limited Character dan Light Cone Banner.', 20, 'StarRailSpecialPass.png', 20, '2026-06-08 15:13:23'),
(9, 'Kafka Acrylic Figure', 'Figure', 'Figur akrilik Kafka dengan pose ikonik. Tinggi 20cm, dilengkapi stand dan packaging eksklusif.', 15, 'KafkaAcrylicFigure.png', 35, '2026-06-08 15:13:23'),
(10, 'Silver Wolf Plush', 'Plush', 'Boneka plush Silver Wolf ukuran 30cm. Bahan super lembut, cocok untuk pajangan atau peluk-pelukin.', 20, 'SilverWolfPlush.png', 25, '2026-06-08 15:13:23'),
(11, 'Blade PVC Figure', 'Figure', 'Figur PVC Blade skala 1/7, tinggi 28cm. Detail cat berkualitas tinggi, pose battle stance.', 10, 'BladePVCFigure.png', 90, '2026-06-08 15:13:23'),
(12, 'Trailblazer Hoodie', 'Apparel', 'Hoodie premium dengan motif logo Trailblaze. Bahan fleece tebal, tersedia ukuran S–XXL. Warna hitam dengan aksen ungu.', 25, 'TrailblazerHoodie.png', 50, '2026-06-08 15:13:23'),
(13, 'HSR Characters Keychain Set', 'Keychain', 'Set 6 gantungan kunci karakter: Kafka, Silver Wolf, Blade, Jing Yuan, Luocha, dan Fu Xuan. Bahan akrilik 5mm.', 35, 'HSRCharactersSet.png', 16, '2026-06-08 15:13:23'),
(14, 'Astral Express Poster Set', 'Poster', 'Set 4 poster A3 art official Honkai: Star Rail. Dicetak di kertas glossy 200gsm, siap dibingkai.', 30, 'AstralExpressPosterSet.png', 13, '2026-06-08 15:13:23'),
(15, 'Pom-Pom Plush XL', 'Plush', 'Maskot Astral Express dalam ukuran jumbo 45cm. Lucu banget, detail pompom di badannya akurat.', 18, 'Pom-PomXL.png', 40, '2026-06-08 15:13:23'),
(16, 'HSR Artbook Vol.1', 'Collectible', 'Buku seni resmi Honkai: Star Rail Volume 1. 200 halaman ilustrasi karakter, environment, dan konsep awal game.', 10, 'HSRArtbookVol_1.png', 45, '2026-06-08 15:13:23');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `resource_id` int(11) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  `total_price` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `user_id`, `resource_id`, `quantity`, `total_price`, `created_at`) VALUES
(1, 8, 1, 3, 30, '2026-05-21 05:36:16'),
(2, 14, 1, 1, 10, '2026-06-08 13:02:30'),
(3, 23, 16, 2, 90, '2026-06-08 15:38:07'),
(4, 24, 1, 1, 10, '2026-06-08 15:47:18'),
(5, 24, 2, 1, 3, '2026-06-08 15:47:20'),
(6, 24, 3, 1, 28, '2026-06-08 15:47:23');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `role` enum('admin','user') DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `created_at`) VALUES
(6, 'Darryl', 'darryl@mail.com', '$2b$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC02pfyf5/5aGPRHyHXW', 'admin', '2026-05-19 07:51:15'),
(7, 'Darryl Google Account', 'darryl.google@gmail.com', '$2b$10$1edp3G/FL.tBTq5F.uuvb.FNT32G/A0N5JPDe3113W2gC/7jZXTPW', 'user', '2026-05-19 07:52:12'),
(8, 'Admin', 'admin2@mail.com', '$2b$10$qsgCHOVPwfFh9iykas2ate8FEDP21I8AMqaA1ZsLVjhuoUAugnLUW', 'admin', '2026-05-21 05:32:50'),
(9, 'New Google User', 'newuser@gmail.com', '$2b$10$5rKmdXb7Buen2308T0ihiuvfCV.e/K4FTh5wxAgVkjWubtedyYA0C', 'user', '2026-05-21 05:40:52'),
(10, 'Admin', 'admin@mail.com', '$2b$10$pl8K0fI/i1z8ZQpXeh4HDe1ge8ekSabo/OZnadXKaa/GpmcQTm0JS', 'admin', '2026-05-26 06:50:36'),
(11, 'darryl arief tananjaya', 'darryltananjaya9@gmail.com', '$2b$10$SfUlvnbxIdQCwIDTAE4JH.Q7uKhNE5OympM1WfAiU/NslWmtur.e6', 'user', '2026-06-07 14:36:38'),
(12, 'Google User 87156', 'googleuser87156@gmail.com', '$2b$10$BUstsqcCKZHTwOzKBfGWXe95uF28Vm2CrA.czQsphQ7lG4IERxKHS', 'user', '2026-06-07 14:48:30'),
(13, 'Google User 48750', 'googleuser48750@gmail.com', '$2b$10$Zp84Xmt7kWzTpSPffbG5qenrGmAzA0SWDKMX2/yv4uMRGWktlwQuG', 'user', '2026-06-08 13:02:06'),
(14, 'Google User 81201', 'googleuser81201@gmail.com', '$2b$10$SEaJ5EmC1NaeS418RvPw3ejKUfReFCYNj9Ww9RcXFORDCu6.VKbvq', 'user', '2026-06-08 13:02:25'),
(15, 'Google User 21993', 'googleuser21993@gmail.com', '$2b$10$mtnhFx1yBqaNCP/6FBhN3OMTulnrZZMJJafavfQWyhhlFiFw8ebk.', 'user', '2026-06-08 14:33:06'),
(16, 'Google User 90291', 'googleuser90291@gmail.com', '$2b$10$R2/zkkWKv0APpRC5/AzjsOarZiZUeQcVRUKUziE.fqwEVg1wEWkQi', 'user', '2026-06-08 14:38:12'),
(17, 'Google User 23263', 'googleuser23263@gmail.com', '$2b$10$9PqYx1h7MjHeifb4XXkWRuviojk0lAPNMGk10K2m3uwsXVOEdZ.EC', 'user', '2026-06-08 14:40:28'),
(18, 'Google User 1655', 'googleuser1655@gmail.com', '$2b$10$ssCBpmm7EL6AOHYfIpVq7upuoMtXJdVyhbhRQhvSrxTeLYU145Nlu', 'user', '2026-06-08 14:43:02'),
(19, 'Google User 19321', 'googleuser19321@gmail.com', '$2b$10$EyogQlsQFqV.EpLKQISDROgDioyxIUWozz1uVojz1gSwdDYw.pqTW', 'user', '2026-06-08 14:44:35'),
(20, 'Google User 74060', 'googleuser74060@gmail.com', '$2b$10$Lkh8JY6NF/VqaS//FN1IteUMHQSj51JkJREJruuShDaPRSYA7ORrS', 'user', '2026-06-08 14:52:24'),
(21, 'Google User 4748', 'googleuser4748@gmail.com', '$2b$10$VQQQfWfbCDzlYWU9RzBlqO4y8Lw0HCS3I0Dhf5unoNTcMX9ysZqym', 'user', '2026-06-08 15:08:33'),
(22, 'Google User 48483', 'googleuser48483@gmail.com', '$2b$10$tmupfc.k2kI.Vz4jaGNmpO30PZiT5Hgz3pgcUuDytGfpBJcrPYu7K', 'user', '2026-06-08 15:33:18'),
(23, 'Google User 28572', 'googleuser28572@gmail.com', '$2b$10$YDZ8avohdEBXiONSaP3.U.W44fUZQ9u4mO.jdrVbX0aqI3lUC2I6u', 'user', '2026-06-08 15:37:51'),
(24, 'Google User 97182', 'googleuser97182@gmail.com', '$2b$10$ENfToTpkLQGi9rBYoezmQ..jSFXuDidZfaxav7lzH6e3bm8fZqaPu', 'user', '2026-06-08 15:45:57');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `resources`
--
ALTER TABLE `resources`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `resources`
--
ALTER TABLE `resources`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
