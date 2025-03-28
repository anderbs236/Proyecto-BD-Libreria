-- MySQL dump 10.13  Distrib 8.0.41, for Linux (x86_64)
--
-- Host: localhost    Database: libreria
-- ------------------------------------------------------
-- Server version	8.0.41-0ubuntu0.24.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `AUTOR`
--

DROP TABLE IF EXISTS `AUTOR`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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

LOCK TABLES `AUTOR` WRITE;
/*!40000 ALTER TABLE `AUTOR` DISABLE KEYS */;
/*!40000 ALTER TABLE `AUTOR` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CLIENTE`
--

DROP TABLE IF EXISTS `CLIENTE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
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

LOCK TABLES `CLIENTE` WRITE;
/*!40000 ALTER TABLE `CLIENTE` DISABLE KEYS */;
/*!40000 ALTER TABLE `CLIENTE` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DETALLE_VENTA`
--

DROP TABLE IF EXISTS `DETALLE_VENTA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DETALLE_VENTA` (
  `VENTA_ID_venta` int NOT NULL,
  `Cantidad` varchar(255) DEFAULT NULL,
  `Precio_venta` varchar(255) DEFAULT NULL,
  `LIBRO_EN_VENTA_ISBN` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`VENTA_ID_venta`),
  KEY `fk_VENTA_has_GUION_LIBRO_VENTA1_idx` (`VENTA_ID_venta`),
  KEY `fk_libro_en_venta` (`LIBRO_EN_VENTA_ISBN`),
  CONSTRAINT `fk_libro_en_venta` FOREIGN KEY (`LIBRO_EN_VENTA_ISBN`) REFERENCES `LIBRO_EN_VENTA` (`ISBN`),
  CONSTRAINT `fk_VENTA_has_GUION_LIBRO_VENTA1` FOREIGN KEY (`VENTA_ID_venta`) REFERENCES `VENTA` (`ID_venta`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DETALLE_VENTA`
--

LOCK TABLES `DETALLE_VENTA` WRITE;
/*!40000 ALTER TABLE `DETALLE_VENTA` DISABLE KEYS */;
/*!40000 ALTER TABLE `DETALLE_VENTA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GENERO`
--

DROP TABLE IF EXISTS `GENERO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GENERO` (
  `ID_genero` int NOT NULL,
  `Genero` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`ID_genero`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GENERO`
--

LOCK TABLES `GENERO` WRITE;
/*!40000 ALTER TABLE `GENERO` DISABLE KEYS */;
/*!40000 ALTER TABLE `GENERO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GUION_LIBRO`
--

DROP TABLE IF EXISTS `GUION_LIBRO`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GUION_LIBRO` (
  `Titulo` varchar(255) NOT NULL,
  `GENERO_ID_genero` int NOT NULL,
  `AUTOR_ID_autor` int NOT NULL,
  PRIMARY KEY (`Titulo`,`AUTOR_ID_autor`),
  KEY `fk_GUION_LIBRO_GENERO1_idx` (`GENERO_ID_genero`),
  KEY `fk_GUION_LIBRO_AUTOR1_idx` (`AUTOR_ID_autor`),
  CONSTRAINT `fk_GUION_LIBRO_AUTOR1` FOREIGN KEY (`AUTOR_ID_autor`) REFERENCES `AUTOR` (`ID_autor`),
  CONSTRAINT `fk_GUION_LIBRO_GENERO1` FOREIGN KEY (`GENERO_ID_genero`) REFERENCES `GENERO` (`ID_genero`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GUION_LIBRO`
--

LOCK TABLES `GUION_LIBRO` WRITE;
/*!40000 ALTER TABLE `GUION_LIBRO` DISABLE KEYS */;
/*!40000 ALTER TABLE `GUION_LIBRO` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LIBRO_EN_VENTA`
--

DROP TABLE IF EXISTS `LIBRO_EN_VENTA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LIBRO_EN_VENTA` (
  `ISBN` varchar(45) NOT NULL,
  `Stock` int DEFAULT NULL,
  `Fecha_publicacion` date DEFAULT NULL,
  `Editorial` varchar(45) DEFAULT NULL,
  `Precio_recomendado` decimal(10,2) DEFAULT NULL,
  `GUION_LIBRO_Titulo` varchar(255) NOT NULL,
  `GUION_LIBRO_AUTOR_ID_autor` int NOT NULL,
  `GUION_LIBRO_ID` int DEFAULT NULL,
  PRIMARY KEY (`ISBN`,`GUION_LIBRO_Titulo`,`GUION_LIBRO_AUTOR_ID_autor`),
  KEY `fk_LIBRO_EN_VENTA_GUION_LIBRO1_idx` (`GUION_LIBRO_Titulo`,`GUION_LIBRO_AUTOR_ID_autor`),
  CONSTRAINT `fk_LIBRO_EN_VENTA_GUION_LIBRO1` FOREIGN KEY (`GUION_LIBRO_Titulo`, `GUION_LIBRO_AUTOR_ID_autor`) REFERENCES `GUION_LIBRO` (`Titulo`, `AUTOR_ID_autor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LIBRO_EN_VENTA`
--

LOCK TABLES `LIBRO_EN_VENTA` WRITE;
/*!40000 ALTER TABLE `LIBRO_EN_VENTA` DISABLE KEYS */;
/*!40000 ALTER TABLE `LIBRO_EN_VENTA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `VENTA`
--

DROP TABLE IF EXISTS `VENTA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `VENTA` (
  `ID_venta` int NOT NULL,
  `Fecha_venta` date DEFAULT NULL,
  `Total` decimal(10,2) DEFAULT NULL,
  `ID_cliente` int DEFAULT NULL,
  PRIMARY KEY (`ID_venta`),
  KEY `VENTA_CLIENTE_FK` (`ID_cliente`),
  CONSTRAINT `VENTA_CLIENTE_FK` FOREIGN KEY (`ID_cliente`) REFERENCES `CLIENTE` (`ID_cliente`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `VENTA`
--

LOCK TABLES `VENTA` WRITE;
/*!40000 ALTER TABLE `VENTA` DISABLE KEYS */;
/*!40000 ALTER TABLE `VENTA` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary view structure for view `Vista_clientes_compras`
--

DROP TABLE IF EXISTS `Vista_clientes_compras`;
/*!50001 DROP VIEW IF EXISTS `Vista_clientes_compras`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `Vista_clientes_compras` AS SELECT 
 1 AS `ID_venta`,
 1 AS `Nombre`,
 1 AS `Apellido1`,
 1 AS `Apellido2`,
 1 AS `Total`*/;
SET character_set_client = @saved_cs_client;

--
-- Final view structure for view `Vista_clientes_compras`
--

/*!50001 DROP VIEW IF EXISTS `Vista_clientes_compras`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`ander`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `Vista_clientes_compras` AS select `v`.`ID_venta` AS `ID_venta`,`c`.`Nombre` AS `Nombre`,`c`.`Apellido1` AS `Apellido1`,`c`.`Apellido2` AS `Apellido2`,`v`.`Total` AS `Total` from (`VENTA` `v` join `CLIENTE` `c` on((`v`.`ID_cliente` = `c`.`ID_cliente`))) where (`v`.`Total` > 100) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-03-20 12:04:28
