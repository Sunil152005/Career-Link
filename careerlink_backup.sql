-- MySQL dump 10.13  Distrib 8.0.39, for Win64 (x86_64)
--
-- Host: localhost    Database: careerlink
-- ------------------------------------------------------
-- Server version	8.0.39

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
-- Current Database: `careerlink`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `careerlink` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `careerlink`;

--
-- Table structure for table `admin_credentials`
--

DROP TABLE IF EXISTS `admin_credentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_credentials` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_credentials`
--

LOCK TABLES `admin_credentials` WRITE;
/*!40000 ALTER TABLE `admin_credentials` DISABLE KEYS */;
INSERT INTO `admin_credentials` VALUES (1,'admin@careerlink.com','65536:AgiHtKyBkSlgFCQjLvxK0Q==:Tynwjtx5+SI6rGfIwef5+OVAWaC2Dvgy+56CpivB0aM=','2026-10-02 06:19:13');
/*!40000 ALTER TABLE `admin_credentials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `application`
--

DROP TABLE IF EXISTS `application`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `application` (
  `application_id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int NOT NULL,
  `job_id` int NOT NULL,
  `apply_date` date NOT NULL,
  `status` varchar(50) DEFAULT 'Applied',
  PRIMARY KEY (`application_id`),
  KEY `candidate_id` (`candidate_id`),
  KEY `job_id` (`job_id`),
  CONSTRAINT `application_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate` (`candidate_id`),
  CONSTRAINT `application_ibfk_2` FOREIGN KEY (`job_id`) REFERENCES `job_post` (`job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `application`
--

LOCK TABLES `application` WRITE;
/*!40000 ALTER TABLE `application` DISABLE KEYS */;
INSERT INTO `application` VALUES (1,3,1,'2026-09-02','Interview Scheduled'),(2,4,1,'2026-09-02','Interview Scheduled');
/*!40000 ALTER TABLE `application` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `candidate`
--

DROP TABLE IF EXISTS `candidate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `candidate` (
  `candidate_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `password` varchar(500) NOT NULL,
  `education` varchar(255) DEFAULT NULL,
  `skills` varchar(500) DEFAULT NULL,
  `experience` varchar(100) DEFAULT NULL,
  `resume_path` varchar(255) DEFAULT NULL,
  `role` varchar(30) NOT NULL DEFAULT 'CANDIDATE',
  PRIMARY KEY (`candidate_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `candidate`
--

LOCK TABLES `candidate` WRITE;
/*!40000 ALTER TABLE `candidate` DISABLE KEYS */;
INSERT INTO `candidate` VALUES (3,'Aditya Bhosale','seeker1@gmail.com','9876543210','65536:uNx3LBzi8AEwMBul+ik2Bw==:vSciuniJu0+1/hbrpJbIXXDTUte0y0u7yjnLKQ/zik0=','Civil','','',NULL,'CANDIDATE'),(4,'Yash Raut','seeker2@gmail.com','9876543210','65536:CuQjzf9q/9S29+3L3lwrWA==:TH3H+JT05mi/yW7JF2H4Wg+a37CYVko88cyRe6zqmW4=','B.tech- Third Year','HTML, CSS, JavaScript, MySQL, Java, AI, ML.','0','uploads/1788343952179_Architecture_dia.png','CANDIDATE'),(6,'Alex Rivera','alex.engineer@linkedin.com','+1 555-0100','65536:pXL/pUXxc5rDmHg3n2/eZA==:5rGsF3OkerNkEr4nWQQBAbaL6DsEdUsc7ENm118Ivus=','Degree in Tech / Business','Java, Problem Solving, Communication','Entry-Mid Level',NULL,'CANDIDATE'),(8,'Sunil Jadhav','sj429012@gmail.com','+918149800895','65536:Mn0Nc/bD4z826/iwEYlT3Q==:s26Utbux6R80Q85Y9GUPLclnIImASGKAMm1uWRLAQg0=','Degree in Engineering / Science / Arts','Java, Problem Solving, Teamwork','Entry-Level / Experienced',NULL,'CANDIDATE'),(9,'Test Candidate','testcandidate@careerlink.com','','65536:6ChOLxy4DAgum+d5Gt4UWQ==:QV0R+cciP2jFehQephkob6Qvlepi/7rZXZsTL45lvE0=','','','',NULL,'CANDIDATE');
/*!40000 ALTER TABLE `candidate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_messages`
--

DROP TABLE IF EXISTS `contact_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_messages` (
  `message_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `subject` varchar(200) NOT NULL,
  `message` text NOT NULL,
  `status` varchar(30) DEFAULT 'Pending',
  `reply` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`message_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_messages`
--

LOCK TABLES `contact_messages` WRITE;
/*!40000 ALTER TABLE `contact_messages` DISABLE KEYS */;
INSERT INTO `contact_messages` VALUES (1,'Sunil Jadhav','recruiter1@gmail.com','Technical Issue or Bug Report','Website is not working properly','Resolved','Issue investigated and resolved by Admin.','2026-09-09 01:23:54');
/*!40000 ALTER TABLE `contact_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hr`
--

DROP TABLE IF EXISTS `hr`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hr` (
  `hr_id` int NOT NULL AUTO_INCREMENT,
  `company_name` varchar(150) NOT NULL,
  `hr_name` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`hr_id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hr`
--

LOCK TABLES `hr` WRITE;
/*!40000 ALTER TABLE `hr` DISABLE KEYS */;
INSERT INTO `hr` VALUES (1,'abc','Sada jir','abc@gmail.com','9876543210','65536:L9u7ZopNhEm6KHXKoN2M6A==:KeEaAqB9kSduag9sZe2olObP9BKSycqqpuNdBpyG9gY='),(2,'abc','Sada jir','admin@careerlink.com','9876543210','65536:zqTqpI6zoqNaTknkE2Yunw==:mxN9ndKOLEyAQ+O9OP4Mqysc9v0QlBKS8Ew97n1e/4o='),(3,'abc','Sunil Jadhav','recruiter1@gmail.com','9876543210','65536:Xw7Ez3VHfm8G04WnHWT2OA==:gPkYeNKTVAKCbAUJSNHKGhP1Gz+ReiG/EZJ6F7PTLHo='),(5,'Rivera Global Tech','Sarah Jenkins','sj429012@gmail.com','+1 555-0199','65536:aScnMxa5Vc8CWAuGj2GDUA==:0wVDzIavTV9tX0HMJMf7O5REiSrqty68lL+ip81yV3k=');
/*!40000 ALTER TABLE `hr` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `interview`
--

DROP TABLE IF EXISTS `interview`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `interview` (
  `interview_id` int NOT NULL AUTO_INCREMENT,
  `candidate_id` int NOT NULL,
  `job_id` int NOT NULL,
  `interview_date` datetime DEFAULT NULL,
  `interview_status` varchar(50) DEFAULT 'Scheduled',
  `meeting_link` varchar(500) DEFAULT NULL,
  `notes` text,
  `interview_mode` varchar(50) DEFAULT 'Online',
  `venue` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`interview_id`),
  KEY `candidate_id` (`candidate_id`),
  KEY `job_id` (`job_id`),
  CONSTRAINT `interview_ibfk_1` FOREIGN KEY (`candidate_id`) REFERENCES `candidate` (`candidate_id`),
  CONSTRAINT `interview_ibfk_2` FOREIGN KEY (`job_id`) REFERENCES `job_post` (`job_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `interview`
--

LOCK TABLES `interview` WRITE;
/*!40000 ALTER TABLE `interview` DISABLE KEYS */;
INSERT INTO `interview` VALUES (1,4,1,'2026-09-10 10:00:00','Completed','https://meet.google.com/gyk-pkpw-bwj','aptitude test','Offline','ganesh mandir, narhe, pune');
/*!40000 ALTER TABLE `interview` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_post`
--

DROP TABLE IF EXISTS `job_post`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_post` (
  `job_id` int NOT NULL AUTO_INCREMENT,
  `hr_id` int NOT NULL,
  `job_title` varchar(150) NOT NULL,
  `description` text,
  `skills` varchar(500) DEFAULT NULL,
  `qualification` varchar(255) DEFAULT NULL,
  `experience` varchar(100) DEFAULT NULL,
  `salary` decimal(12,2) DEFAULT NULL,
  `location` varchar(150) DEFAULT NULL,
  `last_date` date DEFAULT NULL,
  PRIMARY KEY (`job_id`),
  KEY `hr_id` (`hr_id`),
  CONSTRAINT `job_post_ibfk_1` FOREIGN KEY (`hr_id`) REFERENCES `hr` (`hr_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_post`
--

LOCK TABLES `job_post` WRITE;
/*!40000 ALTER TABLE `job_post` DISABLE KEYS */;
INSERT INTO `job_post` VALUES (1,3,'Java Developer','Requirement of sufficient knowledge of Java.','HTML, CSS, JavaScript, MySQL, Java, AI, ML.','B.Tech Third Year - last year','0',50000.00,'Narhe, Pune','2026-12-12');
/*!40000 ALTER TABLE `job_post` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_token`
--

DROP TABLE IF EXISTS `password_reset_token`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_token` (
  `token_id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `role_type` varchar(50) NOT NULL,
  `token_hash` varchar(128) NOT NULL,
  `expiry_time` timestamp NOT NULL,
  `is_used` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`token_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_token`
--

LOCK TABLES `password_reset_token` WRITE;
/*!40000 ALTER TABLE `password_reset_token` DISABLE KEYS */;
INSERT INTO `password_reset_token` VALUES (1,'seeker1@gmail.com','CANDIDATE','f7bed1d8c2707e1e99910fd4ccbc311b59d0fe2c8c9fbd2a94ea602fa82bb67f','2026-09-08 16:37:49',1,'2026-09-08 16:22:49'),(2,'seeker1@gmail.com','CANDIDATE','a9adf0508a3bf7bf7253463c86a824b68fff96044110c4037770c7128d19971b','2026-09-08 18:23:30',0,'2026-09-08 18:08:29');
/*!40000 ALTER TABLE `password_reset_token` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'careerlink'
--

--
-- Dumping routines for database 'careerlink'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-10 14:13:29
