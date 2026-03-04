-- MySQL dump 10.13  Distrib 8.0.45, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: svp_college
-- ------------------------------------------------------
-- Server version	8.0.45

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `admins`
--

DROP TABLE IF EXISTS `admins`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admins` (
  `admin_id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`admin_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admins`
--

LOCK TABLES `admins` WRITE;
/*!40000 ALTER TABLE `admins` DISABLE KEYS */;
INSERT INTO `admins` VALUES (1,'Admin','3b612c75a7b5048a435fb6ec81e52ff92d6d795a8b5a9c17070f6a63c97a53b2','2026-01-30 05:38:29');
/*!40000 ALTER TABLE `admins` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `education_details`
--

DROP TABLE IF EXISTS `education_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `education_details` (
  `edu_id` int NOT NULL AUTO_INCREMENT,
  `admission_id` varchar(20) NOT NULL,
  `qualifying_exam` enum('SSLC','PUC','ITI','OTHER') NOT NULL,
  `register_number` varchar(30) NOT NULL,
  `year_of_passing` year NOT NULL,
  `total_max_marks` int NOT NULL,
  `total_marks_obtained` int NOT NULL,
  `percentage` decimal(5,2) DEFAULT NULL,
  `science_max_marks` int DEFAULT NULL,
  `science_marks_obtained` int DEFAULT NULL,
  `maths_max_marks` int DEFAULT NULL,
  `maths_marks_obtained` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`edu_id`),
  KEY `fk_edu_student` (`admission_id`),
  CONSTRAINT `education_details_ibfk_1` FOREIGN KEY (`admission_id`) REFERENCES `students` (`admission_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_edu_student` FOREIGN KEY (`admission_id`) REFERENCES `students` (`admission_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `education_details`
--

LOCK TABLES `education_details` WRITE;
/*!40000 ALTER TABLE `education_details` DISABLE KEYS */;
INSERT INTO `education_details` VALUES (1,'SVP2026C0012','SSLC','232000481',2023,625,400,NULL,100,70,100,45,'2026-01-30 06:44:55'),(2,'SVP18323','SSLC','2320004818',2023,625,528,NULL,100,70,100,80,'2026-01-30 07:00:11');
/*!40000 ALTER TABLE `education_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `employee_details`
--

DROP TABLE IF EXISTS `employee_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `employee_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_name` varchar(100) NOT NULL,
  `department` varchar(100) NOT NULL,
  `designation` varchar(100) NOT NULL,
  `mobile_no` varchar(15) NOT NULL,
  `employee_type` varchar(30) NOT NULL DEFAULT 'TEACHING',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `employee_details`
--

LOCK TABLES `employee_details` WRITE;
/*!40000 ALTER TABLE `employee_details` DISABLE KEYS */;
INSERT INTO `employee_details` VALUES (1,'Veerabhadrappa','Computer Science and Engineering','Head of Department','9380309055','TEACHING','2026-02-19 14:18:04'),(2,'Roopesh M','Electronics and Communication Engineering','Teaching Staff','6366655132','TEACHING','2026-02-19 14:18:49'),(3,'Arunagiri K P','Computer Science and Engineering','Teaching Staff','7411110125','TEACHING','2026-02-19 14:19:58'),(4,'Chandrashekhar','Automobile Engineering','Head of Department','2654984123','TEACHING','2026-02-19 15:11:53'),(5,'Karbasappa','Mechanical Engineering','Teaching Staff','9654584502','TEACHING','2026-02-19 15:12:38');
/*!40000 ALTER TABLE `employee_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee_payments`
--

DROP TABLE IF EXISTS `fee_payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fee_payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `admission_id` varchar(50) NOT NULL,
  `fee_type` enum('ADMISSION','TUITION','MANAGEMENT','EXAM') NOT NULL,
  `academic_year` varchar(20) DEFAULT NULL,
  `semester_no` tinyint DEFAULT NULL,
  `amount` decimal(10,2) NOT NULL,
  `payment_date` date NOT NULL,
  `receipt_no` varchar(60) NOT NULL,
  `remarks` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `receipt_no` (`receipt_no`),
  KEY `idx_fee_payments_admission_id` (`admission_id`),
  KEY `idx_fee_payments_payment_date` (`payment_date`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee_payments`
--

LOCK TABLES `fee_payments` WRITE;
/*!40000 ALTER TABLE `fee_payments` DISABLE KEYS */;
INSERT INTO `fee_payments` VALUES (1,'SVP12511','ADMISSION','2025-26',NULL,16000.00,'2026-02-20','SVP-20260220151934-777','','2026-02-20 09:49:34'),(2,'SVP2026C0012','ADMISSION','2025-26',NULL,1000.00,'2023-06-10','SVP-20260220152150-874','','2026-02-20 09:51:50'),(3,'SVP2026C0012','TUITION','2023-24',NULL,6000.00,'2026-02-20','SVP-20260220152301-693','','2026-02-20 09:53:01'),(4,'SVP12511','TUITION','2025-26',6,6800.00,'2026-02-20','SVP-20260220153441-997','','2026-02-20 10:04:41'),(5,'SVP97273','ADMISSION','2025-26',1,1000.00,'2026-02-20','SVP-20260220153653-176','','2026-02-20 10:06:53');
/*!40000 ALTER TABLE `fee_payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fee_structure_master`
--

DROP TABLE IF EXISTS `fee_structure_master`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fee_structure_master` (
  `id` int NOT NULL AUTO_INCREMENT,
  `branch` varchar(100) NOT NULL,
  `semester_no` tinyint NOT NULL,
  `academic_year` varchar(20) NOT NULL,
  `admission_fee_due` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tuition_fee_due` decimal(10,2) NOT NULL DEFAULT '0.00',
  `management_fee_due` decimal(10,2) NOT NULL DEFAULT '0.00',
  `exam_fee_due` decimal(10,2) NOT NULL DEFAULT '0.00',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uq_fee_structure_period` (`branch`,`semester_no`,`academic_year`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fee_structure_master`
--

LOCK TABLES `fee_structure_master` WRITE;
/*!40000 ALTER TABLE `fee_structure_master` DISABLE KEYS */;
INSERT INTO `fee_structure_master` VALUES (1,'Computer science and Engineering',6,'2025-26',0.00,6800.00,18000.00,350.00,'2026-02-20 10:04:01'),(2,'Computer science and Engineering',1,'2025-26',1000.00,7000.00,18000.00,0.00,'2026-02-20 10:06:27');
/*!40000 ALTER TABLE `fee_structure_master` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `fees`
--

DROP TABLE IF EXISTS `fees`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `fees` (
  `fee_id` int NOT NULL AUTO_INCREMENT,
  `admission_id` varchar(20) NOT NULL,
  `admission_fee` int DEFAULT '0',
  `tuition_fee` int DEFAULT '0',
  `exam_fee` int DEFAULT '0',
  `payment_status` enum('PAID','PENDING') DEFAULT 'PENDING',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`fee_id`),
  KEY `admission_id` (`admission_id`),
  CONSTRAINT `fees_ibfk_1` FOREIGN KEY (`admission_id`) REFERENCES `students` (`admission_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `fees`
--

LOCK TABLES `fees` WRITE;
/*!40000 ALTER TABLE `fees` DISABLE KEYS */;
INSERT INTO `fees` VALUES (1,'SVP2026C0012',20000,0,350,'PENDING','2026-01-30 06:45:29'),(2,'SVP18323',1200000,50000,200000,'PAID','2026-01-30 07:15:01'),(3,'SVP53906',2000,18000,350,'PAID','2026-02-20 09:21:16');
/*!40000 ALTER TABLE `fees` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `results`
--

DROP TABLE IF EXISTS `results`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `results` (
  `result_id` int NOT NULL AUTO_INCREMENT,
  `admission_id` varchar(20) NOT NULL,
  `semester` varchar(10) DEFAULT NULL,
  `sgpa` decimal(4,2) DEFAULT NULL,
  `result_status` enum('PASS','FAIL') DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`result_id`),
  KEY `admission_id` (`admission_id`),
  CONSTRAINT `results_ibfk_1` FOREIGN KEY (`admission_id`) REFERENCES `students` (`admission_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `results`
--

LOCK TABLES `results` WRITE;
/*!40000 ALTER TABLE `results` DISABLE KEYS */;
/*!40000 ALTER TABLE `results` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `staff_accounts`
--

DROP TABLE IF EXISTS `staff_accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `staff_accounts` (
  `id` int NOT NULL AUTO_INCREMENT,
  `employee_id` int DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `is_verified` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `employee_name` varchar(150) DEFAULT NULL,
  `department` varchar(150) DEFAULT NULL,
  `designation` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `employee_id` (`employee_id`),
  UNIQUE KEY `employee_id_2` (`employee_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `staff_accounts`
--

LOCK TABLES `staff_accounts` WRITE;
/*!40000 ALTER TABLE `staff_accounts` DISABLE KEYS */;
INSERT INTO `staff_accounts` VALUES (1,NULL,'vaishushivakumar2@gmail.com','6ca13d52ca70c883e0f0bb101e425a89e8624de51db2d2392593af6a84118090',1,'2026-02-20 11:09:27','Veerabhadrappa','Computer Science and Engineering',NULL),(2,NULL,'aishu8114@gmail.com','6ca13d52ca70c883e0f0bb101e425a89e8624de51db2d2392593af6a84118090',1,'2026-02-20 11:39:11','ramya','Management Department','Staff');
/*!40000 ALTER TABLE `staff_accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_documents`
--

DROP TABLE IF EXISTS `student_documents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_documents` (
  `id` int NOT NULL AUTO_INCREMENT,
  `admission_id` varchar(20) NOT NULL,
  `aadhaar_number` char(12) DEFAULT NULL,
  `aadhaar_file` varchar(255) DEFAULT NULL,
  `caste_rd_number` varchar(50) DEFAULT NULL,
  `caste_file` varchar(255) DEFAULT NULL,
  `income_rd_number` varchar(50) DEFAULT NULL,
  `income_file` varchar(255) DEFAULT NULL,
  `marks_exam_type` enum('SSLC','PUC','ITI') DEFAULT NULL,
  `marks_card_file` varchar(255) DEFAULT NULL,
  `student_photo` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_documents`
--

LOCK TABLES `student_documents` WRITE;
/*!40000 ALTER TABLE `student_documents` DISABLE KEYS */;
INSERT INTO `student_documents` VALUES (1,'SVP53906','212254658899',NULL,'RD5486359998',NULL,'RD78459621222',NULL,NULL,NULL,NULL,'2026-02-10 16:35:29'),(2,'SVP97273','212254658899',NULL,'RD5486359998',NULL,'RD78459621222',NULL,NULL,NULL,NULL,'2026-02-11 05:58:42'),(3,'SVP78072','212254658899',NULL,'RD5486359998',NULL,'RD78459621222',NULL,NULL,NULL,NULL,'2026-02-11 12:31:24'),(4,'SVP12511','212254658898','SVP12511_aadhaar_image1.jpg','RD5486359999','SVP12511_caste_birth.jpg','RD78459621228','SVP12511_income_appu.jpg',NULL,'SVP12511_marks_e8132034b60c946d61703a0dcdcfe009.jpg','SVP12511_photo_e8132034b60c946d61703a0dcdcfe009.jpg','2026-02-19 18:24:55');
/*!40000 ALTER TABLE `student_documents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_fee_structure`
--

DROP TABLE IF EXISTS `student_fee_structure`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_fee_structure` (
  `id` int NOT NULL AUTO_INCREMENT,
  `admission_id` varchar(50) NOT NULL,
  `admission_fee_due` decimal(10,2) NOT NULL DEFAULT '0.00',
  `tuition_fee_yearly_due` decimal(10,2) NOT NULL DEFAULT '0.00',
  `management_fee_yearly_due` decimal(10,2) NOT NULL DEFAULT '0.00',
  `exam_fee_per_sem_due` decimal(10,2) NOT NULL DEFAULT '0.00',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `admission_id` (`admission_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_fee_structure`
--

LOCK TABLES `student_fee_structure` WRITE;
/*!40000 ALTER TABLE `student_fee_structure` DISABLE KEYS */;
INSERT INTO `student_fee_structure` VALUES (1,'SVP12511',1000.00,6000.00,80000.00,0.00,'2026-02-20 09:48:43'),(2,'SVP2026C0012',1000.00,6000.00,16000.00,350.00,'2026-02-20 09:51:08');
/*!40000 ALTER TABLE `student_fee_structure` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `student_personal_details`
--

DROP TABLE IF EXISTS `student_personal_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student_personal_details` (
  `id` int unsigned NOT NULL AUTO_INCREMENT,
  `admission_id` varchar(20) NOT NULL,
  `student_mobile` char(10) DEFAULT NULL,
  `student_email` varchar(100) DEFAULT NULL,
  `indian_nationality` enum('YES','NO') DEFAULT 'YES',
  `religion` varchar(50) DEFAULT NULL,
  `disability` enum('YES','NO') DEFAULT 'NO',
  `aadhaar_number` char(15) DEFAULT NULL,
  `caste_rd_number` char(15) DEFAULT NULL,
  `caste_certificate_file` varchar(255) DEFAULT NULL,
  `income_rd_number` char(15) DEFAULT NULL,
  `income_certificate_file` varchar(255) DEFAULT NULL,
  `annual_income` decimal(10,2) DEFAULT NULL,
  `mother_name` varchar(100) DEFAULT NULL,
  `mother_mobile` char(10) DEFAULT NULL,
  `father_name` varchar(100) DEFAULT NULL,
  `father_mobile` char(10) DEFAULT NULL,
  `residential_address` text,
  `permanent_address` text,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `photo_file` varchar(255) DEFAULT NULL,
  `marks_card_file` varchar(255) DEFAULT NULL,
  `aadhaar_file` varchar(255) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `gender` varchar(10) DEFAULT NULL,
  `caste_category` varchar(10) DEFAULT NULL,
  `alloted_category` varchar(10) DEFAULT NULL,
  `qualifying_exam` enum('SSLC','CBSE','ICSE','PUC','ITI') DEFAULT NULL,
  `year_of_passing` int DEFAULT NULL,
  `register_number` varchar(30) DEFAULT NULL,
  `admission_quota` enum('Government','SNQ') DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_spd_student` (`admission_id`),
  CONSTRAINT `fk_spd_student` FOREIGN KEY (`admission_id`) REFERENCES `students` (`admission_id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student_personal_details`
--

LOCK TABLES `student_personal_details` WRITE;
/*!40000 ALTER TABLE `student_personal_details` DISABLE KEYS */;
INSERT INTO `student_personal_details` VALUES (1,'SVP17442','7890655678','sahabj@gmail.com','YES','hindu','NO','786556788765','RD897667795','SVP17442_caste_admission_SVP18323.pdf','RD253675485','SVP17442_income_admission_SVP18323.pdf',12245.00,'Mamthaj','9089098767','shajan','8976097689','nnmsnnnxsaxbxzxas','nmabnzaxbbanjka','2026-02-01 06:52:33',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(2,'SVP99859','6366169429','jeevant519@gmail.com','YES','hindu','NO','344227822686','RD897667795','SVP99859_caste_fee_receipt_SVP18323.pdf','RD253675485','SVP99859_income_fee_receipt_SVP18323_2.pdf',150000.00,'anitha','9901954714','thippaya','9008700689','k.hkj.h.dkcsjflksdf','bxbxjznxzklxzl;lk;','2026-02-01 07:48:08',NULL,NULL,NULL,NULL,'','','',NULL,NULL,'',NULL),(3,'SVP46751','7890655678','surii321@gmail.com','YES',NULL,'NO',NULL,NULL,'SVP46751_caste_fee_receipt_SVP18323.pdf',NULL,'SVP46751_income_fee_receipt_SVP18323_2.pdf',NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-02-02 05:16:13','SVP46751_photo_admission_SVP2026C0012.pdf','SVP46751_marks_fee_receipt_SVP2026C0012.pdf',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL),(4,'SVP53906',NULL,NULL,'YES','hindu','NO',NULL,NULL,NULL,NULL,NULL,NULL,'Nethravathi','8618860544','Shivakumar','9964850838','Bangalore','Bangalore','2026-02-10 16:35:29',NULL,NULL,NULL,'2007-10-29','Female','GEN','GM','SSLC',2023,'20228136','Government'),(5,'SVP97273',NULL,NULL,'YES','HINDU','NO',NULL,NULL,NULL,NULL,NULL,NULL,'NETHRAVATHI','','SHIVAKUMAR','9964850838','BANGALORE','BANGALORE','2026-02-11 05:58:42',NULL,NULL,NULL,'2005-02-10','Female','Category-1','1G','SSLC',2023,'20228136','Government'),(6,'SVP78072',NULL,NULL,'YES','HINDU','NO',NULL,NULL,NULL,NULL,NULL,NULL,'NETHRAVATHI','','SHIVA','6548945464','BANGLORE','BANGLORE','2026-02-11 12:31:24',NULL,NULL,NULL,'2003-10-20','Female','Category-1','GM','CBSE',2023,'6598231656','SNQ'),(7,'SVP2026C0012',NULL,NULL,'YES',NULL,'NO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-02-19 16:51:59',NULL,NULL,NULL,NULL,'Male','2A','2AG',NULL,NULL,'56465465632',NULL),(8,'SVP44450',NULL,NULL,'YES',NULL,'NO',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,'2026-02-19 17:41:11',NULL,NULL,NULL,NULL,'','','',NULL,NULL,'',NULL),(9,'SVP12511',NULL,NULL,'YES','HINDU','NO',NULL,NULL,NULL,NULL,NULL,NULL,'GOWRI','','ANAND','8946846546','GOTTIGERE','GOTTIGERE','2026-02-19 18:24:55',NULL,NULL,NULL,'2007-06-10','Female','SC','SCG','ICSE',2023,'5165487998','Government');
/*!40000 ALTER TABLE `student_personal_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `students`
--

DROP TABLE IF EXISTS `students`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `students` (
  `student_id` int NOT NULL AUTO_INCREMENT,
  `admission_id` varchar(20) NOT NULL,
  `student_name` varchar(100) NOT NULL,
  `year_sem` varchar(10) DEFAULT NULL,
  `mobile` varchar(15) DEFAULT NULL,
  `password_hash` varchar(255) NOT NULL,
  `status` enum('INACTIVE','ACTIVE','REJECTED') NOT NULL DEFAULT 'INACTIVE',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `rejection_reason` varchar(255) DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL,
  `branch` varchar(50) NOT NULL,
  `college_reg_no` varchar(100) DEFAULT NULL,
  `admission_year` int DEFAULT NULL,
  PRIMARY KEY (`student_id`),
  UNIQUE KEY `admission_id` (`admission_id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `students`
--

LOCK TABLES `students` WRITE;
/*!40000 ALTER TABLE `students` DISABLE KEYS */;
INSERT INTO `students` VALUES (1,'SVP2026C001','Ravi Kumar','Sem-1','9876543210','703b0a3d6ad75b649a28adde7d83c6251da457549263bc7ff45ec709b0a8448b','ACTIVE','2026-01-30 05:38:38',NULL,NULL,'',NULL,NULL),(2,'SVP2026C0012','Adhi','3','9380309044','28ed3b3b99480c4dd2483d6bf4a305bb39a5c372749a6a9fc804ca82265f4337','ACTIVE','2026-01-30 06:35:25',NULL,NULL,'Automobile Engineering','364CS23046',2023),(11,'SVP62531','surya',NULL,'9380309049','993db1fad2bafdf97d3999d89a71a2c959ca7b1863fdf0dc2d7c07d563c9c928','ACTIVE','2026-01-30 06:47:45',NULL,NULL,'',NULL,NULL),(12,'SVP18323','Vaishnavi S',NULL,'7676260502','69b6005712ad24d5255378d0e105dec80cf21219e00073537c0a6d775f34a662','ACTIVE','2026-01-30 06:57:28',NULL,NULL,'',NULL,NULL),(13,'SVP44450','indu',NULL,'6366424295','abea836b3994b4af23ff11533331ed6fe53c3f585c91f58a525a0b1f4e68fa09','REJECTED','2026-01-30 07:04:16','not accurate information',NULL,'Electronics and Communication Engineering',NULL,NULL),(43,'SVP17442','Sabhaj',NULL,'7890655678','0b7cf65c96590a22119f5a31cacd2ff228a161ca7a27c6bc22c81b11ab9e2994','ACTIVE','2026-02-01 06:52:33',NULL,NULL,'',NULL,NULL),(45,'SVP99859','jeevant',NULL,'6366169429','515ed123bb335b581e9c58dfe3f58f960293525d48bdafad1c02c7d6afe112b7','ACTIVE','2026-02-01 07:48:08',NULL,NULL,'Mechanical Engineering',NULL,NULL),(48,'SVP46751','jaisurya',NULL,'7890655678','4a7089ffa9b7cb95cba0431c7b834577485d4c363dccfec29a52e0f064d3f464','REJECTED','2026-02-02 05:16:13','not accurate information',NULL,'',NULL,NULL),(49,'SVP53906','vaishnavi s',NULL,'7676260502','1940ca03a7942274e24319af47ed062a172466e0406b5498700d3b57a667e1a9','ACTIVE','2026-02-10 16:35:28',NULL,NULL,'',NULL,NULL),(50,'SVP97273','VAISHNAVI ',NULL,'6366551326','e0bebd22819993425814866b62701e2919ea26f1370499c1037b53b9d49c2c8a','ACTIVE','2026-02-11 05:58:42',NULL,NULL,'Computer science and Engineering',NULL,NULL),(51,'SVP78072','VAISHNAVI ',NULL,'6366655132','e0bebd22819993425814866b62701e2919ea26f1370499c1037b53b9d49c2c8a','INACTIVE','2026-02-11 12:31:24',NULL,NULL,'Computer Science and Engineering',NULL,NULL),(52,'SVP12511','BINDU',NULL,'8904366566','6ca13d52ca70c883e0f0bb101e425a89e8624de51db2d2392593af6a84118090','ACTIVE','2026-02-19 18:24:55',NULL,NULL,'Computer Science and Engineering','364CS23002',2023);
/*!40000 ALTER TABLE `students` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-02-20 20:17:15
