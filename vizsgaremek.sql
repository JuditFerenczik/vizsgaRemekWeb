-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2022. Jan 28. 17:57
-- Kiszolgáló verziója: 10.4.21-MariaDB
-- PHP verzió: 8.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Adatbázis: `vizsgaremek`
--

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `beosztasok`
--

CREATE TABLE `beosztasok` (
  `Beosztas_ID` int(11) NOT NULL,
  `Szemely_ID` int(11) NOT NULL,
  `Kezdete` datetime NOT NULL,
  `Vege` datetime NOT NULL,
  `Munkanap` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `jelenletek`
--

CREATE TABLE `jelenletek` (
  `Jelenlet_ID` int(11) NOT NULL,
  `Szemely_ID` int(11) NOT NULL,
  `Kezd` int(11) NOT NULL,
  `Vege` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `jogosultsag`
--

CREATE TABLE `jogosultsag` (
  `jog_ID` int(11) NOT NULL,
  `Megnevezes` varchar(30) COLLATE utf8mb4_hungarian_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szemelyek`
--

CREATE TABLE `szemelyek` (
  `Szemely_ID` int(11) NOT NULL,
  `jog_ID` int(11) NOT NULL COMMENT 'Kapcsolat a Jogosultsagok tablaval.',
  `osztaly_ID` int(11) NOT NULL COMMENT 'Kapcsolat az Osztalyok tablaval.',
  `Munkarend_ID` int(11) NOT NULL,
  `Nev` varchar(50) COLLATE utf8mb4_hungarian_ci NOT NULL,
  `Munkakor` varchar(50) COLLATE utf8mb4_hungarian_ci NOT NULL COMMENT 'Kereskedelmi-osztaly vezeto, vagy kereskedo...',
  `Belepes_Datum` date NOT NULL,
  `E-mail` varchar(50) COLLATE utf8mb4_hungarian_ci NOT NULL COMMENT 'Egy e-mail cim csak egyszer szerepelhet.',
  `Jelszo` varchar(50) COLLATE utf8mb4_hungarian_ci NOT NULL COMMENT 'Egy jelszo csak egyszer szerepelhet.',
  `Napi_munkaido` float NOT NULL DEFAULT 8 COMMENT 'Órában meghatározva.',
  `Munkakozi_szunet` float NOT NULL DEFAULT 20 COMMENT 'Percekben meghatározva.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szemelyjogosultsag`
--

CREATE TABLE `szemelyjogosultsag` (
  `Szemely_ID` int(11) NOT NULL,
  `Jog_ID` int(11) NOT NULL,
  `HatalyDatum` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `beosztasok`
--
ALTER TABLE `beosztasok`
  ADD PRIMARY KEY (`Beosztas_ID`),
  ADD KEY `Szemely_ID` (`Szemely_ID`);

--
-- A tábla indexei `jelenletek`
--
ALTER TABLE `jelenletek`
  ADD PRIMARY KEY (`Jelenlet_ID`),
  ADD UNIQUE KEY `Szemely_ID` (`Szemely_ID`);

--
-- A tábla indexei `jogosultsag`
--
ALTER TABLE `jogosultsag`
  ADD PRIMARY KEY (`jog_ID`);

--
-- A tábla indexei `szemelyek`
--
ALTER TABLE `szemelyek`
  ADD PRIMARY KEY (`Szemely_ID`),
  ADD UNIQUE KEY `email` (`E-mail`),
  ADD UNIQUE KEY `jelszo` (`Jelszo`);

--
-- A tábla indexei `szemelyjogosultsag`
--
ALTER TABLE `szemelyjogosultsag`
  ADD PRIMARY KEY (`Szemely_ID`),
  ADD UNIQUE KEY `Szemely_ID` (`Jog_ID`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `beosztasok`
--
ALTER TABLE `beosztasok`
  MODIFY `Beosztas_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `jelenletek`
--
ALTER TABLE `jelenletek`
  MODIFY `Jelenlet_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT a táblához `szemelyek`
--
ALTER TABLE `szemelyek`
  MODIFY `Szemely_ID` int(11) NOT NULL AUTO_INCREMENT;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `beosztasok`
--
ALTER TABLE `beosztasok`
  ADD CONSTRAINT `beosztasok_ibfk_1` FOREIGN KEY (`Szemely_ID`) REFERENCES `szemelyek` (`Szemely_ID`);

--
-- Megkötések a táblához `jelenletek`
--
ALTER TABLE `jelenletek`
  ADD CONSTRAINT `jelenletek_ibfk_1` FOREIGN KEY (`Szemely_ID`) REFERENCES `szemelyek` (`Szemely_ID`);

--
-- Megkötések a táblához `szemelyjogosultsag`
--
ALTER TABLE `szemelyjogosultsag`
  ADD CONSTRAINT `szemelyjogosultsag_ibfk_1` FOREIGN KEY (`Szemely_ID`) REFERENCES `szemelyek` (`Szemely_ID`),
  ADD CONSTRAINT `szemelyjogosultsag_ibfk_2` FOREIGN KEY (`Jog_ID`) REFERENCES `jogosultsag` (`jog_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
