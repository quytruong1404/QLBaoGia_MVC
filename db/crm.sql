-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Apr 06, 2026 at 07:02 AM
-- Server version: 9.1.0
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `crm`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên danh mục',
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'Trạng thái hiển thị',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

DROP TABLE IF EXISTS `contacts`;
CREATE TABLE IF NOT EXISTS `contacts` (
  `contact_id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` int UNSIGNED NOT NULL COMMENT 'Mã khách hàng/doanh nghiệp',
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên người liên hệ',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Số điện thoại',
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Email',
  `address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Địa chỉ',
  `birthday` date DEFAULT NULL COMMENT 'Ngày sinh nhật',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'Mô tả/Ghi chú',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`contact_id`),
  KEY `fk_contact_customer` (`customer_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `crm_contracts`
--

DROP TABLE IF EXISTS `crm_contracts`;
CREATE TABLE IF NOT EXISTS `crm_contracts` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `contract_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Số hợp đồng chính thức',
  `quote_id` int UNSIGNED NOT NULL COMMENT 'Liên kết báo giá gốc',
  `lead_id` int UNSIGNED NOT NULL COMMENT 'Liên kết khách hàng',
  `contract_date` date NOT NULL COMMENT 'Ngày ký kết',
  `expiration_date` date NOT NULL COMMENT 'Ngày hết hiệu lực hợp đồng',
  `total_value` decimal(15,2) NOT NULL COMMENT 'Giá trị quyết toán hợp đồng',
  `payment_terms` text COLLATE utf8mb4_unicode_ci COMMENT 'Điều khoản thanh toán',
  `manager_id` int UNSIGNED DEFAULT NULL COMMENT 'Nhân viên quản lý hợp đồng',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `contract_number` (`contract_number`),
  KEY `fk_contract_quote` (`quote_id`),
  KEY `fk_contract_lead` (`lead_id`)
) ;

-- --------------------------------------------------------

--
-- Table structure for table `crm_quotes`
--

DROP TABLE IF EXISTS `crm_quotes`;
CREATE TABLE IF NOT EXISTS `crm_quotes` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `quote_number` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Số báo giá',
  `lead_id` int UNSIGNED NOT NULL COMMENT 'Liên kết khách hàng tiềm năng',
  `quote_date` date NOT NULL COMMENT 'Ngày lập báo giá',
  `valid_until` date DEFAULT NULL COMMENT 'Ngày hết hạn báo giá',
  `approval_status` enum('Draft','Pending','Approved','Rejected') COLLATE utf8mb4_unicode_ci DEFAULT 'Draft' COMMENT 'Trạng thái duyệt nội bộ',
  `stage` enum('Draft','Sent','Negotiating','Accepted','Declined') COLLATE utf8mb4_unicode_ci DEFAULT 'Sent' COMMENT 'Giai đoạn thương thảo',
  `total_amount` decimal(15,2) DEFAULT '0.00' COMMENT 'Tổng tiền hàng trước thuế',
  `tax_amount` decimal(15,2) DEFAULT '0.00' COMMENT 'Tổng tiền thuế',
  `discount_amount` decimal(15,2) DEFAULT '0.00' COMMENT 'Tổng tiền chiết khấu',
  `grand_total` decimal(15,2) DEFAULT '0.00' COMMENT 'Tổng cộng cuối cùng khách phải trả',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `quote_number` (`quote_number`),
  KEY `fk_quote_lead` (`lead_id`)
) ;

-- --------------------------------------------------------

--
-- Table structure for table `crm_quote_details`
--

DROP TABLE IF EXISTS `crm_quote_details`;
CREATE TABLE IF NOT EXISTS `crm_quote_details` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `quote_id` int UNSIGNED NOT NULL,
  `product_id` int UNSIGNED NOT NULL COMMENT 'Liên kết sản phẩm',
  `quantity` smallint UNSIGNED NOT NULL DEFAULT '1',
  `unit_price` decimal(15,2) NOT NULL COMMENT 'Đơn giá tại thời điểm báo giá',
  `discount_percent` decimal(5,2) DEFAULT '0.00' COMMENT '% Chiết khấu cho mặt hàng này',
  `tax_rate` decimal(5,2) DEFAULT '10.00' COMMENT '% Thuế suất áp dụng',
  `line_total` decimal(15,2) DEFAULT '0.00' COMMENT 'Thành tiền của dòng này',
  PRIMARY KEY (`id`),
  KEY `fk_quotedetail_quote` (`quote_id`),
  KEY `fk_quotedetail_product` (`product_id`)
) ;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

DROP TABLE IF EXISTS `customers`;
CREATE TABLE IF NOT EXISTS `customers` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Mã khách hàng',
  `customer_type` enum('B2B','B2C') COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Loại khách hàng',
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên KH / Công ty',
  `short_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tên viết tắt',
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `fax` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tax_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'MST (B2B)',
  `identity_number` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'CCCD (B2C)',
  `company_address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Địa chỉ công ty',
  `billing_address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Địa chỉ xuất hóa đơn',
  `established_date` date DEFAULT NULL COMMENT 'Ngày thành lập',
  `website` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `industry` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `source` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `campaign` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `tier_id` tinyint UNSIGNED DEFAULT NULL,
  `status_id` tinyint UNSIGNED DEFAULT NULL,
  `primary_contact_id` int UNSIGNED DEFAULT NULL,
  `assigned_to` int UNSIGNED DEFAULT NULL COMMENT 'Sales phụ trách',
  `description` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `created_by` int UNSIGNED DEFAULT NULL,
  `updated_by` int UNSIGNED DEFAULT NULL,
  `is_deleted` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `customer_code` (`customer_code`),
  KEY `idx_customer_name` (`name`(250)),
  KEY `idx_customer_phone` (`phone`),
  KEY `idx_customer_email` (`email`),
  KEY `fk_customer_tier` (`tier_id`),
  KEY `fk_customer_status` (`status_id`),
  KEY `fk_customer_primary_contact` (`primary_contact_id`)
) ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_statuses`
--

DROP TABLE IF EXISTS `customer_statuses`;
CREATE TABLE IF NOT EXISTS `customer_statuses` (
  `id` tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
  `status_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Đang chăm sóc, Blacklist...',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customer_tiers`
--

DROP TABLE IF EXISTS `customer_tiers`;
CREATE TABLE IF NOT EXISTS `customer_tiers` (
  `id` tinyint UNSIGNED NOT NULL AUTO_INCREMENT,
  `tier_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Bạc, Vàng, Kim cương',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `documents`
--

DROP TABLE IF EXISTS `documents`;
CREATE TABLE IF NOT EXISTS `documents` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_id` int UNSIGNED NOT NULL COMMENT 'Thuộc loại tài liệu nào',
  `parent_id` int UNSIGNED DEFAULT NULL COMMENT 'ID Tài liệu cha',
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên tài liệu',
  `file_name` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Tên file',
  `status` enum('DRAFT','PUBLISHED','EXPIRED','ARCHIVED') COLLATE utf8mb4_unicode_ci DEFAULT 'DRAFT',
  `version` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT 'v1.0' COMMENT 'Phiên bản',
  `is_template` tinyint(1) DEFAULT '0' COMMENT 'Cờ đánh dấu là Tài liệu mẫu',
  `issue_date` date DEFAULT NULL COMMENT 'Ngày phát hành',
  `expiration_date` date DEFAULT NULL COMMENT 'Ngày hết hạn',
  `description` varchar(1000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mô tả chi tiết',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT 'Cờ xóa mềm',
  PRIMARY KEY (`id`),
  KEY `fk_doc_type` (`type_id`),
  KEY `fk_doc_parent` (`parent_id`)
) ;

-- --------------------------------------------------------

--
-- Table structure for table `document_relations`
--

DROP TABLE IF EXISTS `document_relations`;
CREATE TABLE IF NOT EXISTS `document_relations` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `source_doc_id` int UNSIGNED NOT NULL COMMENT 'ID Tài liệu gốc',
  `target_doc_id` int UNSIGNED NOT NULL COMMENT 'ID Tài liệu liên quan',
  `relation_type` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Loại liên quan',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_doc_relation` (`source_doc_id`,`target_doc_id`),
  KEY `fk_relation_target_doc` (`target_doc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `document_types`
--

DROP TABLE IF EXISTS `document_types`;
CREATE TABLE IF NOT EXISTS `document_types` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `type_name` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên loại tài liệu',
  `description` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Mô tả loại',
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'Trạng thái hoạt động',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `leads`
--

DROP TABLE IF EXISTS `leads`;
CREATE TABLE IF NOT EXISTS `leads` (
  `LeadID` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `FullName` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CompanyName` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Email` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Address` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `ProvinceID` int UNSIGNED DEFAULT NULL,
  `ExpectedRevenue` decimal(15,2) DEFAULT '0.00',
  `Website` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `SourceID` int UNSIGNED DEFAULT NULL,
  `CampaignID` int UNSIGNED DEFAULT NULL,
  `TaxCode` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `IdentityCard` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Description` text COLLATE utf8mb4_unicode_ci,
  `Status` enum('New','Contacted','Qualified','Lost','Converted') COLLATE utf8mb4_unicode_ci DEFAULT 'New',
  `SalesTeamID` int UNSIGNED DEFAULT NULL,
  `CreatedAt` datetime DEFAULT CURRENT_TIMESTAMP,
  `UpdatedAt` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`LeadID`)
) ;

-- --------------------------------------------------------

--
-- Table structure for table `lead_activities`
--

DROP TABLE IF EXISTS `lead_activities`;
CREATE TABLE IF NOT EXISTS `lead_activities` (
  `ActivityID` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `LeadID` int UNSIGNED NOT NULL,
  `ActivityType` enum('Call','Email','Meeting','Task') COLLATE utf8mb4_unicode_ci NOT NULL,
  `ActivityDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `Notes` text COLLATE utf8mb4_unicode_ci,
  `CreatedBy` int UNSIGNED DEFAULT NULL,
  PRIMARY KEY (`ActivityID`),
  KEY `fk_lead_activities` (`LeadID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `lead_interested_services`
--

DROP TABLE IF EXISTS `lead_interested_services`;
CREATE TABLE IF NOT EXISTS `lead_interested_services` (
  `LeadID` int UNSIGNED NOT NULL,
  `ServiceID` int UNSIGNED NOT NULL,
  `InterestLevel` enum('Low','Medium','High') COLLATE utf8mb4_unicode_ci DEFAULT 'Medium',
  PRIMARY KEY (`LeadID`,`ServiceID`),
  KEY `fk_interest_service` (`ServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `product_code` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Mã SKU',
  `type_id` int UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên sản phẩm',
  `price` decimal(15,2) NOT NULL DEFAULT '0.00' COMMENT 'Giá bán',
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'Đường dẫn ảnh lưu trên cloud',
  `description` text COLLATE utf8mb4_unicode_ci COMMENT 'Mô tả chi tiết',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_deleted` tinyint(1) DEFAULT '0' COMMENT 'Cờ xóa mềm',
  PRIMARY KEY (`id`),
  UNIQUE KEY `product_code` (`product_code`),
  KEY `fk_product_type` (`type_id`)
) ;

-- --------------------------------------------------------

--
-- Table structure for table `products_services`
--

DROP TABLE IF EXISTS `products_services`;
CREATE TABLE IF NOT EXISTS `products_services` (
  `ServiceID` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `ServiceName` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ServiceType` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`ServiceID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_types`
--

DROP TABLE IF EXISTS `product_types`;
CREATE TABLE IF NOT EXISTS `product_types` (
  `id` int UNSIGNED NOT NULL AUTO_INCREMENT,
  `category_id` int UNSIGNED NOT NULL,
  `type_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Tên loại',
  `is_active` tinyint(1) DEFAULT '1' COMMENT 'Trạng thái hiển thị',
  PRIMARY KEY (`id`),
  KEY `fk_pt_category` (`category_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `contacts`
--
ALTER TABLE `contacts`
  ADD CONSTRAINT `fk_contact_customer` FOREIGN KEY (`customer_id`) REFERENCES `customers` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `crm_contracts`
--
ALTER TABLE `crm_contracts`
  ADD CONSTRAINT `fk_contract_lead` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`LeadID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_contract_quote` FOREIGN KEY (`quote_id`) REFERENCES `crm_quotes` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `crm_quotes`
--
ALTER TABLE `crm_quotes`
  ADD CONSTRAINT `fk_quote_lead` FOREIGN KEY (`lead_id`) REFERENCES `leads` (`LeadID`) ON DELETE CASCADE;

--
-- Constraints for table `crm_quote_details`
--
ALTER TABLE `crm_quote_details`
  ADD CONSTRAINT `fk_quotedetail_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `fk_quotedetail_quote` FOREIGN KEY (`quote_id`) REFERENCES `crm_quotes` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `customers`
--
ALTER TABLE `customers`
  ADD CONSTRAINT `fk_customer_primary_contact` FOREIGN KEY (`primary_contact_id`) REFERENCES `contacts` (`contact_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_customer_status` FOREIGN KEY (`status_id`) REFERENCES `customer_statuses` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_customer_tier` FOREIGN KEY (`tier_id`) REFERENCES `customer_tiers` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `documents`
--
ALTER TABLE `documents`
  ADD CONSTRAINT `fk_doc_parent` FOREIGN KEY (`parent_id`) REFERENCES `documents` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_doc_type` FOREIGN KEY (`type_id`) REFERENCES `document_types` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `document_relations`
--
ALTER TABLE `document_relations`
  ADD CONSTRAINT `fk_relation_source` FOREIGN KEY (`source_doc_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_relation_target_doc` FOREIGN KEY (`target_doc_id`) REFERENCES `documents` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `lead_activities`
--
ALTER TABLE `lead_activities`
  ADD CONSTRAINT `fk_lead_activities` FOREIGN KEY (`LeadID`) REFERENCES `leads` (`LeadID`) ON DELETE CASCADE;

--
-- Constraints for table `lead_interested_services`
--
ALTER TABLE `lead_interested_services`
  ADD CONSTRAINT `fk_interest_lead` FOREIGN KEY (`LeadID`) REFERENCES `leads` (`LeadID`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_interest_service` FOREIGN KEY (`ServiceID`) REFERENCES `products_services` (`ServiceID`) ON DELETE CASCADE;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_product_type` FOREIGN KEY (`type_id`) REFERENCES `product_types` (`id`) ON DELETE RESTRICT;

--
-- Constraints for table `product_types`
--
ALTER TABLE `product_types`
  ADD CONSTRAINT `fk_pt_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
