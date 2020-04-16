-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema abstract_online_store
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema abstract_online_store
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `abstract_online_store` DEFAULT CHARACTER SET utf8 ;
USE `abstract_online_store` ;

-- -----------------------------------------------------
-- Table `abstract_online_store`.`city`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`city` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `abstract_online_store`.`country`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`country` (
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`name`));


-- -----------------------------------------------------
-- Table `abstract_online_store`.`street`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`street` (
  `id` INT NOT NULL,
  `name` VARCHAR(60) NOT NULL,
  `city_id` INT NOT NULL,
  `country` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `street_city` (`city_id` ASC) VISIBLE,
  CONSTRAINT `city_id`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`city` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `country`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`country` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `abstract_online_store`.`address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`address` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `street_id` INT NULL,
  `postal_code` INT NOT NULL,
  `building_number` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `postal_code_UNIQUE` (`postal_code` ASC) VISIBLE,
  INDEX `address_postal_code` (`postal_code` ASC) VISIBLE,
  CONSTRAINT `street_id`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`street` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `abstract_online_store`.`locale`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`locale` (
  `code` VARCHAR(5) NULL);


-- -----------------------------------------------------
-- Table `abstract_online_store`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`customers` (
  `email` VARCHAR(60) NOT NULL,
  `name` VARCHAR(50) NULL,
  `surname` VARCHAR(50) NULL,
  `title` VARCHAR(20) NULL,
  `address_id` INT NULL,
  `locale_code` VARCHAR(5) NULL,
  `gender` INT(2) NULL,
  PRIMARY KEY (`email`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC) VISIBLE,
  INDEX `customers_locale_code` (`locale_code` ASC) VISIBLE,
  INDEX `surname_asc` (`surname` ASC) VISIBLE,
  CONSTRAINT `address_id`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`address` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `locale_code`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`locale` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `abstract_online_store`.`order_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`order_status` (
  `status` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`status`));


-- -----------------------------------------------------
-- Table `abstract_online_store`.`currency`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`currency` (
  `currency_code` VARCHAR(3) NOT NULL,
  PRIMARY KEY (`currency_code`));


-- -----------------------------------------------------
-- Table `abstract_online_store`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `status` VARCHAR(10) NOT NULL,
  `customer` VARCHAR(45) NOT NULL,
  `total` DECIMAL NOT NULL,
  `currency` VARCHAR(3) NULL,
  PRIMARY KEY (`id`),
  INDEX `orders_by_customer` (`customer` ASC) VISIBLE,
  CONSTRAINT `status`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`order_status` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `customer`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`customers` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `currency`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`currency` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `abstract_online_store`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`category` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `parent_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  CONSTRAINT `parent_id`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`category` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `abstract_online_store`.`product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`product` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `product_by_category` (`category_id` ASC) VISIBLE,
  CONSTRAINT `category_id`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`category` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `abstract_online_store`.`product_description`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`product_description` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `text` BLOB NOT NULL,
  `locale` VARCHAR(5) NULL,
  `title` VARCHAR(200) NOT NULL,
  `product_id` INT NULL,
  PRIMARY KEY (`id`),
  INDEX `descriptions_product_id` USING BTREE (`product_id`) VISIBLE,
  CONSTRAINT `locale`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`locale` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `product_id`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`product` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `abstract_online_store`.`order_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`order_history` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `status` VARCHAR(10) NOT NULL,
  `date` DATETIME NOT NULL,
  `order_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `history_by_order_id` (`order_id` ASC) VISIBLE,
  INDEX `history_by_date` () VISIBLE,
  CONSTRAINT `status`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`order_status` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `order_id`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`orders` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `abstract_online_store`.`historical_price`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`historical_price` (
  `id` INT NOT NULL,
  `product_id` INT NULL,
  `currency` VARCHAR(3) NULL,
  `price` INT NULL,
  `active_from` DATETIME NULL,
  PRIMARY KEY (`id`),
  INDEX `historical_price_product_id` (`product_id` ASC) VISIBLE,
  CONSTRAINT `currency`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`currency` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `abstract_online_store`.`product_purchase`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`product_purchase` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `product_id` INT NOT NULL,
  `order_id` INT NOT NULL,
  `price_id` INT NOT NULL,
  `quantity` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `product_purchase_price` USING BTREE (`price_id`) VISIBLE,
  INDEX `product_purchase_product_id` (`product_id` ASC) VISIBLE,
  INDEX `product_purchase_order_id` () VISIBLE,
  CONSTRAINT `product_id`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`product` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `price_id`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`historical_price` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `abstract_online_store`.`delivery_status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`delivery_status` (
  `status` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`status`));


-- -----------------------------------------------------
-- Table `abstract_online_store`.`delivery_history`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `abstract_online_store`.`delivery_history` (
  `id` INT NOT NULL,
  `order_id` INT NOT NULL,
  `address_id` INT NOT NULL,
  `date` DATETIME NOT NULL,
  `delivery_status` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `deliveries_by_order` (`order_id` ASC) VISIBLE,
  INDEX `deliveries_by_address` (`address_id` ASC) VISIBLE,
  INDEX `deliveries_by_date` (`date` ASC) VISIBLE,
  CONSTRAINT `order_id`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`orders` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `address_id`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`address` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `delivery_status`
    FOREIGN KEY ()
    REFERENCES `abstract_online_store`.`delivery_status` ()
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
