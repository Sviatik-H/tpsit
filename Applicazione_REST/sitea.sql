-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Creato il: Mag 08, 2024 alle 17:46
-- Versione del server: 10.4.32-MariaDB
-- Versione PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sitea`
--

-- --------------------------------------------------------

--
-- Struttura della tabella `cart`
--

CREATE TABLE `cart` (
  `CartId` int(11) NOT NULL,
  `UserId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dump dei dati per la tabella `cart`
--

INSERT INTO `cart` (`CartId`, `UserId`) VALUES
(1, 2);

-- --------------------------------------------------------

--
-- Struttura della tabella `cartproduct`
--

CREATE TABLE `cartproduct` (
  `ItemId` int(11) NOT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `UserId` int(11) NOT NULL,
  `ProductId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dump dei dati per la tabella `cartproduct`
--

INSERT INTO `cartproduct` (`ItemId`, `Quantity`, `UserId`, `ProductId`) VALUES
(1, NULL, 2, 2),
(2, NULL, 2, 2),
(3, NULL, 2, 3),
(4, NULL, 2, 3),
(5, NULL, 2, 2),
(6, NULL, 2, 2),
(7, NULL, 2, 2),
(8, NULL, 2, 2),
(9, NULL, 2, 2),
(10, NULL, 2, 2),
(11, NULL, 2, 2),
(12, NULL, 2, 2),
(13, NULL, 2, 2),
(14, NULL, 2, 2),
(15, NULL, 2, 2),
(16, NULL, 2, 2);

-- --------------------------------------------------------

--
-- Struttura della tabella `category`
--

CREATE TABLE `category` (
  `CategoryId` int(11) NOT NULL,
  `Name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dump dei dati per la tabella `category`
--

INSERT INTO `category` (`CategoryId`, `Name`) VALUES
(1, 'Elettronica'),
(2, 'Cosmetici'),
(3, 'Oggetti per la casa'),
(4, 'Abbigliamento'),
(5, 'Alimenti e Bevande'),
(6, 'Giocattoli e Giochi');

-- --------------------------------------------------------

--
-- Struttura della tabella `cookie`
--

CREATE TABLE `cookie` (
  `CookieId` int(11) NOT NULL,
  `Cookie` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `coupon`
--

CREATE TABLE `coupon` (
  `CouponId` int(11) NOT NULL,
  `CouponCode` varchar(10) DEFAULT NULL,
  `ExpirationDate` date DEFAULT NULL,
  `UsesAvailable` int(11) DEFAULT NULL,
  `SpecialCondition` varchar(255) DEFAULT NULL,
  `SpecificProductId` int(11) NOT NULL,
  `SpecificCategoryId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `manufacturer`
--

CREATE TABLE `manufacturer` (
  `ManufacturerId` int(11) NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `Contact` varchar(12) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dump dei dati per la tabella `manufacturer`
--

INSERT INTO `manufacturer` (`ManufacturerId`, `Name`, `Address`, `Contact`) VALUES
(1, 'Apple', 'Via Po', '1');

-- --------------------------------------------------------

--
-- Struttura della tabella `orderproduct`
--

CREATE TABLE `orderproduct` (
  `OrderProductId` int(11) NOT NULL,
  `Quantity` int(11) DEFAULT NULL,
  `Price` float(10,2) DEFAULT NULL,
  `ProductId` int(11) NOT NULL,
  `OrderId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `orderr`
--

CREATE TABLE `orderr` (
  `OrderId` int(11) NOT NULL,
  `OrderState` varchar(255) DEFAULT NULL,
  `UserId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dump dei dati per la tabella `orderr`
--

INSERT INTO `orderr` (`OrderId`, `OrderState`, `UserId`) VALUES
(17, 'Sent', 2),
(18, 'Sent', 2);

-- --------------------------------------------------------

--
-- Struttura della tabella `product`
--

CREATE TABLE `product` (
  `ProductId` int(11) NOT NULL,
  `Name` varchar(255) DEFAULT NULL,
  `Description` varchar(255) DEFAULT NULL,
  `Price` float(10,2) DEFAULT NULL,
  `ManufacturerId` int(11) NOT NULL,
  `CategoryId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dump dei dati per la tabella `product`
--

INSERT INTO `product` (`ProductId`, `Name`, `Description`, `Price`, `ManufacturerId`, `CategoryId`) VALUES
(1, 'iPhone', 'a', 999.00, 1, 1),
(2, 'Divano Letto', 'a', 650.00, 1, 3),
(3, 'Ombretto', 'a', 18.00, 1, 2),
(4, 'Giacca in pelle', 'a', 65.00, 1, 4),
(5, 'Mela', 'a', 1.00, 1, 5),
(6, 'Carte da gioco Uno', 'a', 14.00, 1, 6),
(17, 'Mela', 'a', 1.00, 1, 1);

-- --------------------------------------------------------

--
-- Struttura della tabella `review`
--

CREATE TABLE `review` (
  `ReviewId` int(11) NOT NULL,
  `Review` varchar(255) DEFAULT NULL,
  `Date` date DEFAULT NULL,
  `UserId` int(11) NOT NULL,
  `ProductId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `user`
--

CREATE TABLE `user` (
  `UserId` int(11) NOT NULL,
  `Username` varchar(255) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `Password` varchar(255) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `BillingAddress` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dump dei dati per la tabella `user`
--

INSERT INTO `user` (`UserId`, `Username`, `Email`, `Password`, `Address`, `BillingAddress`) VALUES
(1, 'Capo', 'capo@', 'capo', 'capo123', 'capo123'),
(2, 'v', 'v@gmail.com', 'v', 'v', 'v'),
(3, 'pavan', 'pavan@gmail.com', 'pavan', 'p', 'p');

-- --------------------------------------------------------

--
-- Struttura della tabella `warehouse`
--

CREATE TABLE `warehouse` (
  `WarehouseId` int(11) NOT NULL,
  `Location` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

-- --------------------------------------------------------

--
-- Struttura della tabella `warehouseproduct`
--

CREATE TABLE `warehouseproduct` (
  `WarehouseProductId` int(11) NOT NULL,
  `AvailableAmount` int(11) DEFAULT NULL,
  `WarehouseId` int(11) NOT NULL,
  `ProductId` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Indici per le tabelle scaricate
--

--
-- Indici per le tabelle `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`CartId`),
  ADD KEY `UserId` (`UserId`);

--
-- Indici per le tabelle `cartproduct`
--
ALTER TABLE `cartproduct`
  ADD PRIMARY KEY (`ItemId`),
  ADD KEY `UserId` (`UserId`),
  ADD KEY `ProductId` (`ProductId`);

--
-- Indici per le tabelle `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`CategoryId`);

--
-- Indici per le tabelle `cookie`
--
ALTER TABLE `cookie`
  ADD PRIMARY KEY (`CookieId`);

--
-- Indici per le tabelle `coupon`
--
ALTER TABLE `coupon`
  ADD PRIMARY KEY (`CouponId`),
  ADD KEY `SpecificProductId` (`SpecificProductId`),
  ADD KEY `SpecificCategoryId` (`SpecificCategoryId`);

--
-- Indici per le tabelle `manufacturer`
--
ALTER TABLE `manufacturer`
  ADD PRIMARY KEY (`ManufacturerId`);

--
-- Indici per le tabelle `orderproduct`
--
ALTER TABLE `orderproduct`
  ADD PRIMARY KEY (`OrderProductId`),
  ADD KEY `ProductId` (`ProductId`),
  ADD KEY `OrderId` (`OrderId`);

--
-- Indici per le tabelle `orderr`
--
ALTER TABLE `orderr`
  ADD PRIMARY KEY (`OrderId`),
  ADD KEY `UserId` (`UserId`);

--
-- Indici per le tabelle `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`ProductId`),
  ADD KEY `ManufacturerId` (`ManufacturerId`),
  ADD KEY `CategoryId` (`CategoryId`);

--
-- Indici per le tabelle `review`
--
ALTER TABLE `review`
  ADD PRIMARY KEY (`ReviewId`),
  ADD KEY `UserId` (`UserId`),
  ADD KEY `ProductId` (`ProductId`);

--
-- Indici per le tabelle `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`UserId`);

--
-- Indici per le tabelle `warehouse`
--
ALTER TABLE `warehouse`
  ADD PRIMARY KEY (`WarehouseId`);

--
-- Indici per le tabelle `warehouseproduct`
--
ALTER TABLE `warehouseproduct`
  ADD PRIMARY KEY (`WarehouseProductId`),
  ADD KEY `WarehouseId` (`WarehouseId`),
  ADD KEY `ProductId` (`ProductId`);

--
-- AUTO_INCREMENT per le tabelle scaricate
--

--
-- AUTO_INCREMENT per la tabella `cart`
--
ALTER TABLE `cart`
  MODIFY `CartId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT per la tabella `cartproduct`
--
ALTER TABLE `cartproduct`
  MODIFY `ItemId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT per la tabella `category`
--
ALTER TABLE `category`
  MODIFY `CategoryId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT per la tabella `cookie`
--
ALTER TABLE `cookie`
  MODIFY `CookieId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `coupon`
--
ALTER TABLE `coupon`
  MODIFY `CouponId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `manufacturer`
--
ALTER TABLE `manufacturer`
  MODIFY `ManufacturerId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT per la tabella `orderproduct`
--
ALTER TABLE `orderproduct`
  MODIFY `OrderProductId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `orderr`
--
ALTER TABLE `orderr`
  MODIFY `OrderId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT per la tabella `product`
--
ALTER TABLE `product`
  MODIFY `ProductId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT per la tabella `review`
--
ALTER TABLE `review`
  MODIFY `ReviewId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `user`
--
ALTER TABLE `user`
  MODIFY `UserId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT per la tabella `warehouse`
--
ALTER TABLE `warehouse`
  MODIFY `WarehouseId` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT per la tabella `warehouseproduct`
--
ALTER TABLE `warehouseproduct`
  MODIFY `WarehouseProductId` int(11) NOT NULL AUTO_INCREMENT;

--
-- Limiti per le tabelle scaricate
--

--
-- Limiti per la tabella `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `user` (`UserId`);

--
-- Limiti per la tabella `cartproduct`
--
ALTER TABLE `cartproduct`
  ADD CONSTRAINT `cartproduct_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `user` (`UserId`),
  ADD CONSTRAINT `cartproduct_ibfk_2` FOREIGN KEY (`ProductId`) REFERENCES `product` (`ProductId`);

--
-- Limiti per la tabella `coupon`
--
ALTER TABLE `coupon`
  ADD CONSTRAINT `coupon_ibfk_1` FOREIGN KEY (`SpecificProductId`) REFERENCES `product` (`ProductId`),
  ADD CONSTRAINT `coupon_ibfk_2` FOREIGN KEY (`SpecificCategoryId`) REFERENCES `category` (`CategoryId`);

--
-- Limiti per la tabella `orderproduct`
--
ALTER TABLE `orderproduct`
  ADD CONSTRAINT `orderproduct_ibfk_1` FOREIGN KEY (`ProductId`) REFERENCES `product` (`ProductId`),
  ADD CONSTRAINT `orderproduct_ibfk_2` FOREIGN KEY (`OrderId`) REFERENCES `orderr` (`OrderId`);

--
-- Limiti per la tabella `orderr`
--
ALTER TABLE `orderr`
  ADD CONSTRAINT `orderr_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `user` (`UserId`);

--
-- Limiti per la tabella `product`
--
ALTER TABLE `product`
  ADD CONSTRAINT `product_ibfk_1` FOREIGN KEY (`ManufacturerId`) REFERENCES `manufacturer` (`ManufacturerId`),
  ADD CONSTRAINT `product_ibfk_2` FOREIGN KEY (`CategoryId`) REFERENCES `category` (`CategoryId`);

--
-- Limiti per la tabella `review`
--
ALTER TABLE `review`
  ADD CONSTRAINT `review_ibfk_1` FOREIGN KEY (`UserId`) REFERENCES `user` (`UserId`),
  ADD CONSTRAINT `review_ibfk_2` FOREIGN KEY (`ProductId`) REFERENCES `product` (`ProductId`);

--
-- Limiti per la tabella `warehouseproduct`
--
ALTER TABLE `warehouseproduct`
  ADD CONSTRAINT `warehouseproduct_ibfk_1` FOREIGN KEY (`WarehouseId`) REFERENCES `warehouse` (`WarehouseId`),
  ADD CONSTRAINT `warehouseproduct_ibfk_2` FOREIGN KEY (`ProductId`) REFERENCES `product` (`ProductId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
