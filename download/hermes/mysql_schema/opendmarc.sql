/*
Navicat MySQL Data Transfer

Source Server         : hermes secure email gateway template 16.04 64 -GOLD VMWARE
Source Server Version : 50727
Source Host           : 192.168.20.11:3306
Source Database       : opendmarc

Target Server Type    : MYSQL
Target Server Version : 50727
File Encoding         : 65001

Date: 2019-11-20 13:01:50
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `domains`
-- ----------------------------
DROP TABLE IF EXISTS `domains`;
CREATE TABLE `domains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `firstseen` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of domains
-- ----------------------------

-- ----------------------------
-- Table structure for `ipaddr`
-- ----------------------------
DROP TABLE IF EXISTS `ipaddr`;
CREATE TABLE `ipaddr` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `addr` varchar(64) NOT NULL,
  `firstseen` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `addr` (`addr`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ipaddr
-- ----------------------------

-- ----------------------------
-- Table structure for `messages`
-- ----------------------------
DROP TABLE IF EXISTS `messages`;
CREATE TABLE `messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `jobid` varchar(128) NOT NULL,
  `reporter` int(10) unsigned NOT NULL,
  `policy` tinyint(3) unsigned NOT NULL,
  `disp` tinyint(3) unsigned NOT NULL,
  `ip` int(10) unsigned NOT NULL,
  `env_domain` int(10) unsigned NOT NULL,
  `from_domain` int(10) unsigned NOT NULL,
  `policy_domain` int(10) unsigned NOT NULL,
  `spf` tinyint(4) NOT NULL,
  `align_dkim` tinyint(3) unsigned NOT NULL,
  `align_spf` tinyint(3) unsigned NOT NULL,
  `sigcount` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reporter` (`reporter`,`date`,`jobid`),
  KEY `date` (`date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of messages
-- ----------------------------

-- ----------------------------
-- Table structure for `reporters`
-- ----------------------------
DROP TABLE IF EXISTS `reporters`;
CREATE TABLE `reporters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `firstseen` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of reporters
-- ----------------------------

-- ----------------------------
-- Table structure for `requests`
-- ----------------------------
DROP TABLE IF EXISTS `requests`;
CREATE TABLE `requests` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` int(11) NOT NULL,
  `repuri` varchar(255) NOT NULL,
  `adkim` tinyint(4) NOT NULL,
  `aspf` tinyint(4) NOT NULL,
  `policy` tinyint(4) NOT NULL,
  `spolicy` tinyint(4) NOT NULL,
  `pct` tinyint(4) NOT NULL,
  `locked` tinyint(4) NOT NULL DEFAULT '0',
  `firstseen` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `lastsent` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `domain` (`domain`),
  KEY `lastsent` (`lastsent`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of requests
-- ----------------------------

-- ----------------------------
-- Table structure for `signatures`
-- ----------------------------
DROP TABLE IF EXISTS `signatures`;
CREATE TABLE `signatures` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `message` int(11) NOT NULL,
  `domain` int(11) NOT NULL,
  `pass` tinyint(4) NOT NULL,
  `error` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `message` (`message`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of signatures
-- ----------------------------
