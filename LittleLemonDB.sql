-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema LLemonDB
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema LLemonDB
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `LLemonDB` DEFAULT CHARACTER SET utf8 ;
USE `LLemonDB` ;

-- -----------------------------------------------------
-- Table `LLemonDB`.`TB_CUSTOMER_DETAILS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LLemonDB`.`TB_CUSTOMER_DETAILS` (
  `CUSTOMER_ID` INT NOT NULL AUTO_INCREMENT,
  `TB_CUSTOMER_DETAILScol` VARCHAR(45) NULL,
  `CUSTOMER_NAME` VARCHAR(155) NULL,
  `CUSTOMER_SURNAME` VARCHAR(155) NULL,
  `CUSTOMER_PHONE_NUMBER` VARCHAR(155) NULL,
  `CUSTOMER_EMAIL` VARCHAR(155) NULL,
  PRIMARY KEY (`CUSTOMER_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LLemonDB`.`TB_BOOKINGS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LLemonDB`.`TB_BOOKINGS` (
  `BOOKING_ID` INT NOT NULL AUTO_INCREMENT,
  `BOOKING_DATE` DATE NULL,
  `TABLE_NUMBER` INT NULL,
  `CUSTOMER_ID` INT NOT NULL,
  PRIMARY KEY (`BOOKING_ID`),
  INDEX `CUSTOMER_BOOKING_idx` (`CUSTOMER_ID` ASC) VISIBLE,
  CONSTRAINT `CUSTOMER_BOOKING`
    FOREIGN KEY (`CUSTOMER_ID`)
    REFERENCES `LLemonDB`.`TB_CUSTOMER_DETAILS` (`CUSTOMER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LLemonDB`.`MENU_ITEM_CATEGORIES`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LLemonDB`.`MENU_ITEM_CATEGORIES` (
  `CATEGORY_ID` INT NOT NULL AUTO_INCREMENT,
  `CATEGORY_NAME` VARCHAR(155) NOT NULL,
  PRIMARY KEY (`CATEGORY_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LLemonDB`.`TB_MENU`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LLemonDB`.`TB_MENU` (
  `MENU_ITEM_ID` INT NOT NULL AUTO_INCREMENT,
  `MENU_ITEM_NAME` VARCHAR(155) NULL,
  `MENU_ITEM_CATEGORY_ID` INT NULL,
  PRIMARY KEY (`MENU_ITEM_ID`),
  INDEX `MENU_CATEGORIES_idx` (`MENU_ITEM_CATEGORY_ID` ASC) VISIBLE,
  CONSTRAINT `MENU_CATEGORIES`
    FOREIGN KEY (`MENU_ITEM_CATEGORY_ID`)
    REFERENCES `LLemonDB`.`MENU_ITEM_CATEGORIES` (`CATEGORY_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LLemonDB`.`TB_ORDERS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LLemonDB`.`TB_ORDERS` (
  `ORDER_ID` INT NOT NULL AUTO_INCREMENT,
  `ORDER_DATE` DATE NULL,
  `QUANTITY` INT NULL,
  `TOTAL_COST` DECIMAL(15,2) NULL,
  `CUSTOMER_ID` INT NULL,
  `MENU_ITEM_ID` INT NULL,
  PRIMARY KEY (`ORDER_ID`),
  INDEX `MENU_ITEM_idx` (`MENU_ITEM_ID` ASC) VISIBLE,
  INDEX `CUSTOMER_idx` (`CUSTOMER_ID` ASC) VISIBLE,
  CONSTRAINT `MENU_ITEM`
    FOREIGN KEY (`MENU_ITEM_ID`)
    REFERENCES `LLemonDB`.`TB_MENU` (`MENU_ITEM_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `CUSTOMER`
    FOREIGN KEY (`CUSTOMER_ID`)
    REFERENCES `LLemonDB`.`TB_CUSTOMER_DETAILS` (`CUSTOMER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LLemonDB`.`TB_ORDER_DELIVERY_STATUS`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LLemonDB`.`TB_ORDER_DELIVERY_STATUS` (
  `ORDER_STATUS_ID` INT NOT NULL AUTO_INCREMENT,
  `STATUS_DESCRIPTION` VARCHAR(155) NULL,
  `ORDER_ID` INT NULL,
  `DATE` DATE NULL,
  PRIMARY KEY (`ORDER_STATUS_ID`),
  INDEX `ORDER_ID_idx` (`ORDER_ID` ASC) VISIBLE,
  CONSTRAINT `ORDER_ID`
    FOREIGN KEY (`ORDER_ID`)
    REFERENCES `LLemonDB`.`TB_ORDERS` (`ORDER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `LLemonDB`.`TB_STAFF`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `LLemonDB`.`TB_STAFF` (
  `STAFF_ID` INT NOT NULL AUTO_INCREMENT,
  `NAME` VARCHAR(145) NULL,
  `ROLE` VARCHAR(145) NULL,
  `ORDER_TAKEN` INT NULL,
  PRIMARY KEY (`STAFF_ID`),
  INDEX `ORDER_TAKEN_idx` (`ORDER_TAKEN` ASC) VISIBLE,
  CONSTRAINT `ORDER_TAKEN`
    FOREIGN KEY (`ORDER_TAKEN`)
    REFERENCES `LLemonDB`.`TB_ORDERS` (`ORDER_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
