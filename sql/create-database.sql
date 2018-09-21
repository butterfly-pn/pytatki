-- MySQL Script generated by MySQL Workbench
-- Tue Sep 11 13:40:41 2018
-- Model: New Model    Version: 1.0
-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema pytatki
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema pytatki
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `pytatki` DEFAULT CHARACTER SET utf8 ;
USE `pytatki` ;

-- -----------------------------------------------------
-- Table `pytatki`.`status`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pytatki`.`status` (
  `idstatus` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`idstatus`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pytatki`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pytatki`.`user` (
  `iduser` INT NOT NULL AUTO_INCREMENT,
  `login` VARCHAR(45) NOT NULL,
  `password` VARCHAR(200) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `email_confirm` BINARY(1) NOT NULL DEFAULT 0,
  `status_id` INT NOT NULL,
  PRIMARY KEY (`iduser`),
  INDEX `fk_user_status_idx` (`status_id` ASC),
  CONSTRAINT `fk_user_status`
    FOREIGN KEY (`status_id`)
    REFERENCES `pytatki`.`status` (`idstatus`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pytatki`.`usergroup`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pytatki`.`usergroup` (
  `idusergroup` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `color` VARCHAR(7) NOT NULL DEFAULT '#ffffff',
  `description` LONGTEXT NULL,
  `image_path` VARCHAR(200) NOT NULL DEFAULT 'img/default.jpg',
  `parent_id` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`idusergroup`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pytatki`.`user_membership`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pytatki`.`user_membership` (
  `iduser_membership` INT NOT NULL AUTO_INCREMENT,
  `usergroup_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  PRIMARY KEY (`iduser_membership`),
  INDEX `fk_user_membership_usergroup1_idx` (`usergroup_id` ASC),
  INDEX `fk_user_membership_user1_idx` (`user_id` ASC),
  CONSTRAINT `fk_user_membership_usergroup1`
    FOREIGN KEY (`usergroup_id`)
    REFERENCES `pytatki`.`usergroup` (`idusergroup`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_user_membership_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `pytatki`.`user` (`iduser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pytatki`.`note_type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pytatki`.`note_type` (
  `idnote_type` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `description` LONGTEXT NULL,
  PRIMARY KEY (`idnote_type`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pytatki`.`note`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pytatki`.`note` (
  `idnote` INT NOT NULL AUTO_INCREMENT,
  `value` LONGTEXT NOT NULL,
  `title` VARCHAR(45) NOT NULL DEFAULT 'New note',
  `note_type_id` INT NOT NULL,
  `user_id` INT NOT NULL,
  `usergroup_id` INT NOT NULL,
  `status_id` INT NOT NULL,
  PRIMARY KEY (`idnote`),
  INDEX `fk_note_note_type1_idx` (`note_type_id` ASC),
  INDEX `fk_note_user1_idx` (`user_id` ASC),
  INDEX `fk_note_usergroup1_idx` (`usergroup_id` ASC),
  CONSTRAINT `fk_note_note_type1`
    FOREIGN KEY (`note_type_id`)
    REFERENCES `pytatki`.`note_type` (`idnote_type`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_note_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `pytatki`.`user` (`iduser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_note_usergroup1`
    FOREIGN KEY (`usergroup_id`)
    REFERENCES `pytatki`.`usergroup` (`idusergroup`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pytatki`.`tag`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pytatki`.`tag` (
  `idtag` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`idtag`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pytatki`.`tagging`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pytatki`.`tagging` (
  `idtagging` INT NOT NULL AUTO_INCREMENT,
  `note_id` INT NOT NULL,
  `tag_id` INT NOT NULL,
  PRIMARY KEY (`idtagging`),
  INDEX `fk_tagging_note1_idx` (`note_id` ASC),
  INDEX `fk_tagging_tag1_idx` (`tag_id` ASC),
  CONSTRAINT `fk_tagging_note1`
    FOREIGN KEY (`note_id`)
    REFERENCES `pytatki`.`note` (`idnote`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tagging_tag1`
    FOREIGN KEY (`tag_id`)
    REFERENCES `pytatki`.`tag` (`idtag`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `pytatki`.`action`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pytatki`.`action` (
  `idaction` INT NOT NULL AUTO_INCREMENT,
  `content` LONGTEXT NULL,
  `user_id` INT NOT NULL,
  `note_id` INT NOT NULL,
  `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`idaction`),
  INDEX `fk_action_user1_idx` (`user_id` ASC),
  INDEX `fk_action_note1_idx` (`note_id` ASC),
  CONSTRAINT `fk_action_user1`
    FOREIGN KEY (`user_id`)
    REFERENCES `pytatki`.`user` (`iduser`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_action_note1`
    FOREIGN KEY (`note_id`)
    REFERENCES `pytatki`.`note` (`idnote`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

USE `pytatki` ;

-- -----------------------------------------------------
-- Placeholder table for view `pytatki`.`usergroup_membership`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pytatki`.`usergroup_membership` (`id_user` INT, `login` INT, `idusergroup` INT, `name` INT, `color` INT, `description` INT, `image_path` INT);

-- -----------------------------------------------------
-- Placeholder table for view `pytatki`.`note_view`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pytatki`.`note_view` (`idnote` INT, `value` INT, `title` INT, `'note_type'` INT, `'creator_id'` INT, `'creator_login'` INT, `usergroup_id` INT, `'usergroup_name'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `pytatki`.`action_view`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pytatki`.`action_view` (`idaction` INT, `content` INT, `user_id` INT, `'login_user'` INT, `note_id` INT, `title` INT, `date` INT);

-- -----------------------------------------------------
-- Placeholder table for view `pytatki`.`user_view`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pytatki`.`user_view` (`iduser` INT, `login` INT, `password` INT, `email` INT, `email_confirm` INT, `status_id` INT, `'status_name'` INT);

-- -----------------------------------------------------
-- Placeholder table for view `pytatki`.`note_tags`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `pytatki`.`note_tags` (`idnote` INT, `tag_id` INT, `'tag_name'` INT);

-- -----------------------------------------------------
-- View `pytatki`.`usergroup_membership`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pytatki`.`usergroup_membership`;
USE `pytatki`;
CREATE  OR REPLACE VIEW `usergroup_membership` AS
SELECT a.iduser, a.login, b.idusergroup, b.name, b.color, b.description, b.image_path FROM user a, usergroup b, user_membership c WHERE a.id_user = c.user_id AND b.idusergroup = c.usergroup_id;

-- -----------------------------------------------------
-- View `pytatki`.`note_view`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pytatki`.`note_view`;
USE `pytatki`;
CREATE  OR REPLACE VIEW `note_view` AS
SELECT a.idnote, a.value, a.title, b.name AS 'note_type', a.user_id AS 'creator_id',  c.login AS 'creator_login', a.usergroup_id AS 'parent_id', d.name AS 'parent_name' FROM note a, note_type b, user c, usergroup d WHERE a.note_type_id = b.idnote_type AND a.user_id = c.iduser AND a.usergroup_id = d.idusergroup;

-- -----------------------------------------------------
-- View `pytatki`.`action_view`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pytatki`.`action_view`;
USE `pytatki`;
CREATE  OR REPLACE VIEW `action_view` AS
select a.idaction, a.content, a.user_id, b.login AS 'login_user', a.note_id, c.title, a.date FROM action a, user b, note c WHERE a.user_id = b.iduser AND a.note_id = c.idnote;

-- -----------------------------------------------------
-- View `pytatki`.`user_view`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pytatki`.`user_view`;
USE `pytatki`;
CREATE  OR REPLACE VIEW `user_view` AS
SELECT a.*, b.name AS 'status_name' FROM user a, status b WHERE a.status_id = b.idstatus;

-- -----------------------------------------------------
-- View `pytatki`.`note_tags`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `pytatki`.`note_tags`;
USE `pytatki`;
CREATE  OR REPLACE VIEW `note_tags` AS
SELECT b.idnote, a.tag_id, c.name AS 'tag_name' FROM tagging a, note b, tag c WHERE a.note_id = b.idnote AND a.tag_id = c.idtag;
CREATE USER 'pytatki' IDENTIFIED BY 'pytatki';

GRANT ALL ON `pytatki`.* TO 'pytatki';

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
