-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Gép: 127.0.0.1
-- Létrehozás ideje: 2022. Már 03. 16:51
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
-- Adatbázis: `vizsgaremek_db`
--

DELIMITER $$
--
-- Függvények
--
CREATE DEFINER=`root`@`localhost` FUNCTION `napJelleg` (`datum` DATE) RETURNS INT(11) READS SQL DATA
BEGIN
-- 1 = munkanap
-- 2 = pihenőnap
-- 3 = ünnepnap
-- 4 = szombatra áthelyezett munkanap
-- 5 = szombat
-- 6 = vasárnap
DECLARE v INT;
-- ünnepnapot vizsgálunk
SELECT COUNT(*) INTO v FROM unnepnapok WHERE unnepnapok.unnepnap = datum;
IF v>0 THEN 
    RETURN 3; 
END IF;

-- WEEKDAY() -> 0 = Monday, 1 = Tuesday, 2 = Wednesday, 3 = Thursday, 4 = Friday, 5 = Saturday, 6 = Sunday

-- vasárnapot keresünk
IF WEEKDAY(datum)=6 THEN RETURN 6; END IF;
-- szombatot vizsgálunk
IF WEEKDAY(datum)=5 THEN
	SELECT COUNT(*) INTO v FROM athelyezett WHERE athelyezett.athelyezett = datum;
	RETURN IF(v>0,4,5); 
END IF;
-- munkanap áthelyezést vizsgálunk
SELECT COUNT(*) INTO v FROM pihenonap WHERE pihenonap.pihenonap = datum;
IF v>0 THEN 
	RETURN 2; 
END IF;
RETURN 1;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `jelenletik`
--

CREATE TABLE `jelenletik` (
  `szemely_id` int(11) NOT NULL,
  `datum` date NOT NULL,
  `statusz` enum('ledolgozott','tappenz','szabadsag','fiz_unnep','piheno') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `keresek`
--

CREATE TABLE `keresek` (
  `szemely_id` int(11) NOT NULL,
  `datum` date NOT NULL,
  `statusz` enum('tappenz','szabadsag') NOT NULL,
  `allapot` enum('elinditva','elfogadva') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `munkarend`
--

CREATE TABLE `munkarend` (
  `munkarend_id` int(11) NOT NULL,
  `munkakozi_szunet` int(11) NOT NULL DEFAULT 20 COMMENT 'Percekben meghatározva',
  `kezdes` time NOT NULL DEFAULT '08:00:00',
  `befejezes` time NOT NULL DEFAULT '16:20:00',
  `szunet_kezd` time NOT NULL DEFAULT '12:00:00',
  `szunet_vege` time NOT NULL DEFAULT '12:20:00',
  `ledolgozott_ora` int(11) NOT NULL DEFAULT 8
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `munkarend`
--

INSERT INTO `munkarend` (`munkarend_id`, `munkakozi_szunet`, `kezdes`, `befejezes`, `szunet_kezd`, `szunet_vege`, `ledolgozott_ora`) VALUES
(0, 20, '08:00:00', '16:20:00', '12:00:00', '12:20:00', 8),
(1, 20, '00:00:00', '00:00:00', '00:00:00', '00:00:00', 8);

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `munkaszunetek`
--

CREATE TABLE `munkaszunetek` (
  `datum` date NOT NULL,
  `title` varchar(23) DEFAULT NULL,
  `description` varchar(42) DEFAULT NULL,
  `fizetett` enum('true','false') NOT NULL DEFAULT 'false'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `munkaszunetek`
--

INSERT INTO `munkaszunetek` (`datum`, `title`, `description`, `fizetett`) VALUES
('2022-01-01', 'Új Év napja', 'munkaszüneti nap (hétvége)', 'false'),
('2022-03-14', 'pihenőnap', 'pihenő nap (4 napos hétvége)', 'false'),
('2022-03-15', 'Nemzeti ünnep', 'munkaszüneti nap (4 napos hétvége)', 'true'),
('2022-03-26', 'munkanap', 'áthelyezett munkanap (március 14. helyett)', 'false'),
('2022-04-15', 'Nagypéntek', 'munkaszüneti nap (4 napos hétvége)', 'true'),
('2022-04-18', 'Húsvét', 'munkaszüneti nap (4 napos hétvége)', 'true'),
('2022-05-01', 'Munka Ünnep', 'munkaszüneti nap (hétvége)', 'false'),
('2022-06-06', 'Pünkösd', 'munkaszüneti nap (3 napos hétvége)', 'true'),
('2022-08-20', 'Államalapítás ünnepe', 'munkaszüneti nap (hétvége)', 'false'),
('2022-10-15', 'munkanap', 'áthelyezett munkanap (október 31. helyett)', 'false'),
('2022-10-23', '56-os forradalom ünnepe', 'munkaszüneti nap (hétvége)', 'false'),
('2022-10-31', 'pihenőnap', 'pihenőnap (4 napos hétvége)', 'false'),
('2022-11-01', 'Mindenszentek', 'munkaszüneti nap (4 napos hétvége)', 'true'),
('2022-12-24', 'Szenteste', 'pihenőnap (3 napos hétvége)', 'false'),
('2022-12-25', 'Karácsony', 'munkaszüneti nap (3 napos hétvége)', 'false'),
('2022-12-26', 'Karácsony', 'munkaszüneti nap (3 napos hétvége)', 'true');

-- --------------------------------------------------------

--
-- Tábla szerkezet ehhez a táblához `szemelyek`
--

CREATE TABLE `szemelyek` (
  `szemely_id` int(11) NOT NULL,
  `nev` varchar(30) NOT NULL,
  `adoazonosito` int(10) NOT NULL,
  `fonok` int(11) NOT NULL COMMENT 'A beosztott főnökének neve, ha üres, akkor ő a vezető, nincs főnöke.',
  `munkarend` int(11) NOT NULL COMMENT '0 - kötött\r\n1 - kötetlen',
  `belepes` date NOT NULL,
  `email` varchar(30) NOT NULL,
  `jelszo` varchar(500) NOT NULL,
  `eves_szabadsag` int(11) NOT NULL COMMENT 'Szabadnapok száma.',
  `heti_munkaido` int(11) NOT NULL COMMENT 'Heti óraszám.'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- A tábla adatainak kiíratása `szemelyek`
--

INSERT INTO `szemelyek` (`szemely_id`, `nev`, `adoazonosito`, `fonok`, `munkarend`, `belepes`, `email`, `jelszo`, `eves_szabadsag`, `heti_munkaido`) VALUES
(2, 'Kovács István', 1527938761, 0, 1, '2021-08-01', 'kovacs@gmail.com', '7110eda4d09e062aa5e4a390b0a572ac0d2c0220', 25, 40),
(3, 'Veres Péter', 1234567891, 2, 0, '2022-01-03', 'veres@gmail.com', '7110eda4d09e062aa5e4a390b0a572ac0d2c0220', 28, 40);

--
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `jelenletik`
--
ALTER TABLE `jelenletik`
  ADD KEY `szemely_id` (`szemely_id`),
  ADD KEY `datum` (`datum`);

--
-- A tábla indexei `keresek`
--
ALTER TABLE `keresek`
  ADD PRIMARY KEY (`szemely_id`),
  ADD KEY `datum` (`datum`);

--
-- A tábla indexei `munkarend`
--
ALTER TABLE `munkarend`
  ADD PRIMARY KEY (`munkarend_id`);

--
-- A tábla indexei `munkaszunetek`
--
ALTER TABLE `munkaszunetek`
  ADD PRIMARY KEY (`datum`);

--
-- A tábla indexei `szemelyek`
--
ALTER TABLE `szemelyek`
  ADD PRIMARY KEY (`szemely_id`),
  ADD KEY `munkarend` (`munkarend`),
  ADD KEY `fonok` (`fonok`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `szemelyek`
--
ALTER TABLE `szemelyek`
  MODIFY `szemely_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `jelenletik`
--
ALTER TABLE `jelenletik`
  ADD CONSTRAINT `jelenletik_ibfk_1` FOREIGN KEY (`szemely_id`) REFERENCES `szemelyek` (`szemely_id`),
  ADD CONSTRAINT `jelenletik_ibfk_2` FOREIGN KEY (`datum`) REFERENCES `napok` (`datum`);

--
-- Megkötések a táblához `keresek`
--
ALTER TABLE `keresek`
  ADD CONSTRAINT `keresek_ibfk_1` FOREIGN KEY (`szemely_id`) REFERENCES `jelenletik` (`szemely_id`),
  ADD CONSTRAINT `keresek_ibfk_2` FOREIGN KEY (`datum`) REFERENCES `munkaszunetek` (`datum`);

--
-- Megkötések a táblához `munkaszunetek`
--
ALTER TABLE `munkaszunetek`
  ADD CONSTRAINT `munkaszunetek_ibfk_1` FOREIGN KEY (`datum`) REFERENCES `napok` (`datum`);

--
-- Megkötések a táblához `szemelyek`
--
ALTER TABLE `szemelyek`
  ADD CONSTRAINT `szemelyek_ibfk_1` FOREIGN KEY (`munkarend`) REFERENCES `munkarend` (`munkarend_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
