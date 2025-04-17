-- MySQL dump 10.13  Distrib 5.7.30, for Win64 (x86_64)
--
-- Host: 18.205.133.168    Database: libreria
-- ------------------------------------------------------
-- Server version	8.0.41-0ubuntu0.22.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `AUTOR`
--

CREATE TABLE `AUTOR` (
  `ID_autor` int NOT NULL,
  `Nombre` varchar(45) DEFAULT NULL,
  `Apellido1` varchar(45) DEFAULT NULL,
  `Apellido2` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ID_autor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `AUTOR`
--

/*!40000 ALTER TABLE `AUTOR` DISABLE KEYS */;
CREATE TABLE `CLIENTE` (
  `ID_cliente` int NOT NULL,
  `Nombre` varchar(45) DEFAULT NULL,
  `Apellido1` varchar(45) DEFAULT NULL,
  `Apellido2` varchar(45) DEFAULT NULL,
  `Email` varchar(45) DEFAULT NULL,
  `Telefono` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ID_cliente`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CLIENTE`
--

/*!40000 ALTER TABLE `CLIENTE` DISABLE KEYS */;
CREATE TABLE `DETALLE_VENTA` (
  `id_venta` int NOT NULL,
  `ISBN` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `Titulo` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `id_autor` int DEFAULT NULL,
  `cantidad` int DEFAULT NULL,
  `Precio_unitario` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `subtotal` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`id_venta`,`ISBN`),
  KEY `fk_VENTA_has_GUION_LIBRO_VENTA1_idx` (`id_venta`),
  KEY `fk_libro_en_venta` (`ISBN`),
  KEY `fk_detalle_libro` (`ISBN`,`Titulo`,`id_autor`),
  CONSTRAINT `DETALLE_VENTA_LIBRO_EN_VENTA_FK` FOREIGN KEY (`ISBN`, `Titulo`, `id_autor`) REFERENCES `LIBRO_EN_VENTA` (`ISBN`, `Titulo`, `id_autor`),
  CONSTRAINT `fk_detalle_venta_venta` FOREIGN KEY (`id_venta`) REFERENCES `VENTA` (`ID_venta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DETALLE_VENTA`
--

/*!40000 ALTER TABLE `DETALLE_VENTA` DISABLE KEYS */;
CREATE TABLE `GENERO` (
  `ID_genero` int NOT NULL,
  `Genero` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ID_genero`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GENERO`
--

/*!40000 ALTER TABLE `GENERO` DISABLE KEYS */;
CREATE TABLE `GENERO_GUION` (
  `titulo` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `id_autor` int NOT NULL,
  `id_genero` int NOT NULL,
  PRIMARY KEY (`id_genero`,`titulo`,`id_autor`),
  KEY `titulo` (`titulo`,`id_autor`),
  CONSTRAINT `GENERO_GUION_ibfk_1` FOREIGN KEY (`id_genero`) REFERENCES `GENERO` (`ID_genero`),
  CONSTRAINT `GENERO_GUION_ibfk_2` FOREIGN KEY (`titulo`, `id_autor`) REFERENCES `GUION_LIBRO` (`Titulo`, `id_autor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GENERO_GUION`
--

/*!40000 ALTER TABLE `GENERO_GUION` DISABLE KEYS */;
CREATE TABLE `GUION_LIBRO` (
  `Titulo` varchar(255) NOT NULL,
  `id_autor` int NOT NULL,
  `sinopsis` text,
  PRIMARY KEY (`Titulo`,`id_autor`),
  KEY `fk_GUION_LIBRO_AUTOR1_idx` (`id_autor`),
  CONSTRAINT `fk_GUION_LIBRO_AUTOR1` FOREIGN KEY (`id_autor`) REFERENCES `AUTOR` (`ID_autor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GUION_LIBRO`
--

/*!40000 ALTER TABLE `GUION_LIBRO` DISABLE KEYS */;
CREATE TABLE `LIBRO_EN_VENTA` (
  `ISBN` varchar(45) NOT NULL,
  `Titulo` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `id_autor` int NOT NULL,
  `Editorial` varchar(45) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci DEFAULT NULL,
  `Stock` int DEFAULT NULL,
  `Fecha_publicacion` date DEFAULT NULL,
  `Precio_recomendado` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`ISBN`,`Titulo`,`id_autor`),
  KEY `fk_LIBRO_EN_VENTA_GUION_LIBRO1_idx` (`Titulo`,`id_autor`),
  CONSTRAINT `fk_LIBRO_EN_VENTA_GUION_LIBRO1` FOREIGN KEY (`Titulo`, `id_autor`) REFERENCES `GUION_LIBRO` (`Titulo`, `id_autor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LIBRO_EN_VENTA`
--

/*!40000 ALTER TABLE `LIBRO_EN_VENTA` DISABLE KEYS */;
CREATE TABLE `VENTA` (
  `ID_venta` int NOT NULL,
  `Fecha_venta` date DEFAULT NULL,
  `Precio_total` decimal(10,2) DEFAULT NULL,
  `ID_cliente` int DEFAULT NULL,
  PRIMARY KEY (`ID_venta`),
  KEY `VENTA_CLIENTE_FK` (`ID_cliente`),
  CONSTRAINT `VENTA_CLIENTE_FK` FOREIGN KEY (`ID_cliente`) REFERENCES `CLIENTE` (`ID_cliente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VENTA`
--

/*!40000 ALTER TABLE `VENTA` DISABLE KEYS */;
