-- MySQL dump 10.13  Distrib 9.5.0, for Win64 (x86_64)
--
-- Host: localhost    Database: flotaste
-- ------------------------------------------------------
-- Server version	9.5.0

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ 'bd3be6a6-cd58-11f0-817c-60189549f673:1-112';

--
-- Table structure for table `buses`
--

DROP TABLE IF EXISTS `buses`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `buses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `numero_identificador` varchar(7) COLLATE utf8mb4_general_ci NOT NULL,
  `generacion_id` int NOT NULL,
  `modelo_id` int NOT NULL,
  `deposito_base_id` int DEFAULT NULL,
  `deposito_actual_id` int DEFAULT NULL,
  `año` year NOT NULL,
  `km_actual` int DEFAULT '0',
  `fecha_ingreso` date NOT NULL,
  `estado` enum('activo','inactivo','mantenimiento') COLLATE utf8mb4_general_ci DEFAULT 'activo',
  `kilometros_entre_mantenimientos` int DEFAULT '10000' COMMENT 'Para alertas predictivas',
  `observaciones` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_identificador` (`numero_identificador`),
  UNIQUE KEY `numero_identificador_2` (`numero_identificador`),
  KEY `idx_generacion_id` (`generacion_id`),
  KEY `idx_numero_identificador` (`numero_identificador`),
  KEY `idx_estado` (`estado`),
  KEY `idx_deposito_base` (`deposito_base_id`),
  KEY `idx_deposito_actual` (`deposito_actual_id`),
  KEY `idx_modelo` (`modelo_id`),
  CONSTRAINT `buses_ibfk_1` FOREIGN KEY (`generacion_id`) REFERENCES `generaciones` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `buses_ibfk_2` FOREIGN KEY (`deposito_base_id`) REFERENCES `depositos` (`id`) ON DELETE SET NULL,
  CONSTRAINT `buses_ibfk_3` FOREIGN KEY (`deposito_actual_id`) REFERENCES `depositos` (`id`) ON DELETE SET NULL,
  CONSTRAINT `buses_ibfk_4` FOREIGN KEY (`modelo_id`) REFERENCES `modelos` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buses`
--

LOCK TABLES `buses` WRITE;
/*!40000 ALTER TABLE `buses` DISABLE KEYS */;
INSERT INTO `buses` VALUES (12,'20000',1,1,NULL,NULL,2020,0,'2020-01-01','activo',10000,NULL,'2025-11-30 01:45:26','2025-11-30 01:45:26'),(13,'20001',1,1,NULL,NULL,2020,0,'2020-01-01','activo',10000,NULL,'2025-11-30 01:45:28','2025-11-30 01:45:28'),(14,'20002',1,1,NULL,NULL,2020,0,'2020-01-01','activo',10000,NULL,'2025-11-30 01:45:30','2025-11-30 01:45:30');
/*!40000 ALTER TABLE `buses` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = cp850 */ ;
/*!50003 SET character_set_results = cp850 */ ;
/*!50003 SET collation_connection  = cp850_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`usuario_principal`@`localhost`*/ /*!50003 TRIGGER `generar_numero_identificador` BEFORE INSERT ON `buses` FOR EACH ROW BEGIN
    UPDATE generaciones 
    SET contador_actual = contador_actual + 1 
    WHERE id = NEW.generacion_id;

    SET NEW.numero_identificador = CONCAT(
        LEFT((SELECT codigo FROM generaciones WHERE id = NEW.generacion_id), 3),  
        LPAD((SELECT contador_actual FROM generaciones WHERE id = NEW.generacion_id), 2, '0')
    );
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `depositos`
--

DROP TABLE IF EXISTS `depositos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `depositos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(10) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Ej: DEP-NOR, DEP-SUR, TAL-CEN',
  `nombre` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Depósito Norte, Taller Central, etc.',
  `direccion` text COLLATE utf8mb4_general_ci,
  `telefono` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `responsable` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `subgerente_id` int DEFAULT NULL,
  `capacidad_maxima` int DEFAULT '50' COMMENT 'Cuántos buses caben',
  `es_taller` tinyint(1) DEFAULT '0' COMMENT '1 = sí tiene taller propio, 0 = solo estacionamiento',
  `estado` enum('activo','inactivo') COLLATE utf8mb4_general_ci DEFAULT 'activo',
  `observaciones` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`),
  KEY `idx_codigo` (`codigo`),
  KEY `idx_es_taller` (`es_taller`),
  KEY `idx_subgerente` (`subgerente_id`),
  CONSTRAINT `depositos_ibfk_1` FOREIGN KEY (`subgerente_id`) REFERENCES `empleados` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `depositos`
--

LOCK TABLES `depositos` WRITE;
/*!40000 ALTER TABLE `depositos` DISABLE KEYS */;
/*!40000 ALTER TABLE `depositos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `detalles_mantenimiento`
--

DROP TABLE IF EXISTS `detalles_mantenimiento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `detalles_mantenimiento` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mantenimiento_id` int NOT NULL,
  `autobus_numero` varchar(10) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Copia de numero_identificador para reportes rápidos',
  `km` int NOT NULL,
  `subtipo` enum('A','B','ciclico') COLLATE utf8mb4_general_ci NOT NULL,
  `fecha` date NOT NULL,
  `ot` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Copia de OT para trazabilidad',
  `turno` enum('mañana','tarde','noche') COLLATE utf8mb4_general_ci NOT NULL,
  `observaciones` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `mantenimiento_id` (`mantenimiento_id`),
  CONSTRAINT `detalles_mantenimiento_ibfk_1` FOREIGN KEY (`mantenimiento_id`) REFERENCES `mantenimientos` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `detalles_mantenimiento`
--

LOCK TABLES `detalles_mantenimiento` WRITE;
/*!40000 ALTER TABLE `detalles_mantenimiento` DISABLE KEYS */;
/*!40000 ALTER TABLE `detalles_mantenimiento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empleados`
--

DROP TABLE IF EXISTS `empleados`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleados` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `puesto` enum('jefe_oficina','subjefe_oficina','subgerente','supervisor','tecnico','operario_primera','operario_segunda') COLLATE utf8mb4_general_ci NOT NULL,
  `numero_expediente` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Ej: EXP-00123',
  `deposito_id` int DEFAULT NULL COMMENT 'FK si asignado a un depósito específico',
  `email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `telefono` varchar(20) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `estado` enum('activo','inactivo') COLLATE utf8mb4_general_ci DEFAULT 'activo',
  `observaciones` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `numero_expediente` (`numero_expediente`),
  KEY `idx_puesto` (`puesto`),
  KEY `idx_deposito_id` (`deposito_id`),
  KEY `idx_numero_expediente` (`numero_expediente`),
  CONSTRAINT `empleados_ibfk_1` FOREIGN KEY (`deposito_id`) REFERENCES `depositos` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empleados`
--

LOCK TABLES `empleados` WRITE;
/*!40000 ALTER TABLE `empleados` DISABLE KEYS */;
/*!40000 ALTER TABLE `empleados` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `generaciones`
--

DROP TABLE IF EXISTS `generaciones`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `generaciones` (
  `id` int NOT NULL AUTO_INCREMENT,
  `codigo` varchar(5) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Ej: 20000, 21000, 22000',
  `nombre` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Ej: "Generación 2020"',
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL COMMENT 'NULL si activa',
  `capacidad_total` int DEFAULT '200' COMMENT 'Máximo buses en esta generación',
  `contador_actual` int DEFAULT '0' COMMENT 'Próximo número secuencial (ej: para 20000, inicia en 1 para 20001)',
  `estado` enum('activa','finalizada') COLLATE utf8mb4_general_ci DEFAULT 'activa',
  `observaciones` text COLLATE utf8mb4_general_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `codigo` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `generaciones`
--

LOCK TABLES `generaciones` WRITE;
/*!40000 ALTER TABLE `generaciones` DISABLE KEYS */;
INSERT INTO `generaciones` VALUES (1,'20000','Generacion 20000','2020-01-01',NULL,200,2,'activa',NULL,'2025-11-30 01:04:40','2025-11-30 01:45:30'),(2,'21000','Generacion 21000','2021-01-01',NULL,200,0,'activa',NULL,'2025-11-30 01:05:10','2025-11-30 01:05:10'),(3,'22000','Generacion 22000','2022-01-01',NULL,200,0,'activa',NULL,'2025-11-30 01:05:27','2025-11-30 01:05:27'),(4,'23000','Generacion 23000','2023-01-01',NULL,200,0,'activa',NULL,'2025-11-30 01:05:42','2025-11-30 01:05:42'),(5,'24000','Generacion 24000','2024-01-01',NULL,200,0,'activa',NULL,'2025-11-30 01:05:56','2025-11-30 01:05:56');
/*!40000 ALTER TABLE `generaciones` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `historial_estado`
--

DROP TABLE IF EXISTS `historial_estado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `historial_estado` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bus_id` int NOT NULL,
  `estado_anterior` enum('activo','inactivo','mantenimiento') COLLATE utf8mb4_general_ci DEFAULT NULL,
  `estado_nuevo` enum('activo','inactivo','mantenimiento') COLLATE utf8mb4_general_ci NOT NULL,
  `fecha_cambio` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `motivo` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `usuario` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `bus_id` (`bus_id`),
  CONSTRAINT `historial_estado_ibfk_1` FOREIGN KEY (`bus_id`) REFERENCES `buses` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `historial_estado`
--

LOCK TABLES `historial_estado` WRITE;
/*!40000 ALTER TABLE `historial_estado` DISABLE KEYS */;
/*!40000 ALTER TABLE `historial_estado` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mantenimientos`
--

DROP TABLE IF EXISTS `mantenimientos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mantenimientos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ot` varchar(20) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Orden de Trabajo, ej: OT-2025-001',
  `bus_id` int NOT NULL,
  `fecha_inicio` date NOT NULL,
  `fecha_fin` date DEFAULT NULL COMMENT 'NULL si en proceso',
  `tipo` enum('preventivo','correctivo','predictivo') COLLATE utf8mb4_general_ci NOT NULL,
  `subtipo` enum('A','B','ciclico') COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Para detalles específicos',
  `turno` enum('mañana','tarde','noche') COLLATE utf8mb4_general_ci NOT NULL,
  `km_en_momento` int NOT NULL COMMENT 'KM del bus al inicio',
  `descripcion` text COLLATE utf8mb4_general_ci,
  `taller` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `mecanico_responsable` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `supervisor_id` int DEFAULT NULL,
  `ejecutor_id` int DEFAULT NULL,
  `area` enum('mecanico','electrico','electronico','garantia','otro') COLLATE utf8mb4_general_ci DEFAULT 'mecanico' COMMENT 'Para separar por áreas en futuro',
  `deposito_mantenimiento_id` int DEFAULT NULL,
  `observaciones` text COLLATE utf8mb4_general_ci,
  `estado` enum('programado','en_proceso','completado','cancelado') COLLATE utf8mb4_general_ci DEFAULT 'programado',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ot` (`ot`),
  KEY `idx_bus_id` (`bus_id`),
  KEY `idx_tipo` (`tipo`),
  KEY `idx_area` (`area`),
  KEY `idx_fecha_inicio` (`fecha_inicio`),
  KEY `idx_deposito_mantenimiento` (`deposito_mantenimiento_id`),
  KEY `idx_supervisor` (`supervisor_id`),
  KEY `idx_ejecutor` (`ejecutor_id`),
  CONSTRAINT `mantenimientos_ibfk_1` FOREIGN KEY (`bus_id`) REFERENCES `buses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `mantenimientos_ibfk_2` FOREIGN KEY (`deposito_mantenimiento_id`) REFERENCES `depositos` (`id`) ON DELETE SET NULL,
  CONSTRAINT `mantenimientos_ibfk_3` FOREIGN KEY (`supervisor_id`) REFERENCES `empleados` (`id`) ON DELETE SET NULL,
  CONSTRAINT `mantenimientos_ibfk_4` FOREIGN KEY (`ejecutor_id`) REFERENCES `empleados` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mantenimientos`
--

LOCK TABLES `mantenimientos` WRITE;
/*!40000 ALTER TABLE `mantenimientos` DISABLE KEYS */;
/*!40000 ALTER TABLE `mantenimientos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `marcas`
--

DROP TABLE IF EXISTS `marcas`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `marcas` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Ej: Yutong, Zhongtong',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `marcas`
--

LOCK TABLES `marcas` WRITE;
/*!40000 ALTER TABLE `marcas` DISABLE KEYS */;
INSERT INTO `marcas` VALUES (1,'Yutong'),(2,'Zhongtong');
/*!40000 ALTER TABLE `marcas` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `modelos`
--

DROP TABLE IF EXISTS `modelos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `modelos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Ej: ZK5120C',
  `marca_id` int NOT NULL,
  `capacidad_pasajeros` int NOT NULL COMMENT 'Ej: 85, 142',
  PRIMARY KEY (`id`),
  UNIQUE KEY `nombre` (`nombre`),
  KEY `marca_id` (`marca_id`),
  CONSTRAINT `modelos_ibfk_1` FOREIGN KEY (`marca_id`) REFERENCES `marcas` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `modelos`
--

LOCK TABLES `modelos` WRITE;
/*!40000 ALTER TABLE `modelos` DISABLE KEYS */;
INSERT INTO `modelos` VALUES (1,'ZK5120C',1,85),(2,'ZK5180C',1,142);
/*!40000 ALTER TABLE `modelos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rastreos`
--

DROP TABLE IF EXISTS `rastreos`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rastreos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `bus_id` int NOT NULL,
  `mantenimiento_id` int DEFAULT NULL COMMENT 'Si está ligado a un mantenimiento',
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `latitud` decimal(10,8) DEFAULT NULL,
  `longitud` decimal(11,8) DEFAULT NULL,
  `km_actual` int DEFAULT NULL,
  `velocidad` int DEFAULT NULL,
  `fuente_api` varchar(50) COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Ej: "Google Maps", "API Flota"',
  `observaciones` text COLLATE utf8mb4_general_ci,
  PRIMARY KEY (`id`),
  KEY `mantenimiento_id` (`mantenimiento_id`),
  KEY `idx_bus_id_timestamp` (`bus_id`,`timestamp`),
  CONSTRAINT `rastreos_ibfk_1` FOREIGN KEY (`bus_id`) REFERENCES `buses` (`id`) ON DELETE CASCADE,
  CONSTRAINT `rastreos_ibfk_2` FOREIGN KEY (`mantenimiento_id`) REFERENCES `mantenimientos` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rastreos`
--

LOCK TABLES `rastreos` WRITE;
/*!40000 ALTER TABLE `rastreos` DISABLE KEYS */;
/*!40000 ALTER TABLE `rastreos` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_general_ci NOT NULL COMMENT 'Hash con bcrypt',
  `rol` enum('user','admin') COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'user',
  `nombre` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `idx_username` (`username`),
  KEY `idx_rol` (`rol`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','$2b$10$3hg1R/lon2KwjC6S8tl7n.eoP0bcHwIt8eaojpnd3YN2XsJgEVIY.','admin','Administrador',NULL,'2025-12-01 03:58:55','2025-12-01 03:58:55');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-12 22:11:05
