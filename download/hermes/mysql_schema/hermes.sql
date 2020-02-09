/*


Source Server         : hermes secure email gateway template 16.04 64 -GOLD VMWARE
Source Server Version : 50724
Source Host           : 192.168.xx.xx
Source Database       : hermes

Target Server Type    : MYSQL
Target Server Version : 50724
File Encoding         : 65001

Date: 2019-11-16 06:47:51
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `ad_import_temp`
-- ----------------------------
DROP TABLE IF EXISTS `ad_import_temp`;
CREATE TABLE `ad_import_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `policy_id` int(11) DEFAULT NULL,
  `recipient` varchar(255) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `delete_id` int(11) DEFAULT NULL,
  `pdf_enabled` int(11) DEFAULT NULL,
  `smime_enabled` int(11) DEFAULT NULL,
  `digital_sign` int(11) DEFAULT NULL,
  `validity` varchar(255) DEFAULT NULL,
  `encryption` varchar(255) DEFAULT NULL,
  `algorithm` varchar(255) DEFAULT NULL,
  `smime_password` varchar(255) DEFAULT NULL,
  `smime_certificate_key` varchar(255) DEFAULT NULL,
  `pfx_certificate_name` varchar(255) DEFAULT NULL,
  `smime_certificate_request` varchar(255) DEFAULT NULL,
  `smime_certificate_name` varchar(255) DEFAULT NULL,
  `ca_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=10445 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ad_import_temp
-- ----------------------------

-- ----------------------------
-- Table structure for `ad_integration`
-- ----------------------------
DROP TABLE IF EXISTS `ad_integration`;
CREATE TABLE `ad_integration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entry_name` varchar(255) DEFAULT NULL,
  `dc_name` varchar(255) DEFAULT NULL,
  `fqdn_domain` varchar(255) DEFAULT NULL,
  `netbios_domain` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `objectclass` varchar(255) DEFAULT NULL,
  `scheduled` int(11) DEFAULT NULL,
  `scheduled_interval` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=48 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ad_integration
-- ----------------------------

-- ----------------------------
-- Table structure for `aliases`
-- ----------------------------
DROP TABLE IF EXISTS `aliases`;
CREATE TABLE `aliases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alias` varchar(255) DEFAULT NULL,
  `maps` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of aliases
-- ----------------------------
INSERT INTO `aliases` VALUES ('1', 'postmaster', 'deeztek@hotmail.com');
INSERT INTO `aliases` VALUES ('2', 'MAILER-DAEMON', 'postmaster');
INSERT INTO `aliases` VALUES ('3', 'abuse', 'postmaster');
INSERT INTO `aliases` VALUES ('5', 'ham', 'postmaster');
INSERT INTO `aliases` VALUES ('6', 'spam', 'postmaster');

-- ----------------------------
-- Table structure for `amavis_sender_bypass`
-- ----------------------------
DROP TABLE IF EXISTS `amavis_sender_bypass`;
CREATE TABLE `amavis_sender_bypass` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` varchar(255) DEFAULT NULL,
  `transport` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of amavis_sender_bypass
-- ----------------------------

-- ----------------------------
-- Table structure for `archive_jobs`
-- ----------------------------
DROP TABLE IF EXISTS `archive_jobs`;
CREATE TABLE `archive_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entry_name` varchar(255) DEFAULT NULL,
  `share` varchar(255) DEFAULT NULL,
  `domain` varchar(255) DEFAULT NULL,
  `server` varchar(255) DEFAULT NULL,
  `directory` varchar(255) DEFAULT NULL,
  `mysqlusername` varchar(255) DEFAULT NULL,
  `mysqlpassword` varchar(255) DEFAULT NULL,
  `customtrans` varchar(255) DEFAULT NULL,
  `startdate` timestamp NULL DEFAULT NULL,
  `enddate` timestamp NULL DEFAULT NULL,
  `jobstartdate` timestamp NULL DEFAULT NULL,
  `jobenddate` timestamp NULL DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT '',
  `pid` varchar(255) DEFAULT NULL,
  `archive_date` date DEFAULT NULL,
  `archive_interval` int(11) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `notification` varchar(255) DEFAULT NULL,
  `scheduled_interval` varchar(255) DEFAULT NULL,
  `initial_count` int(11) DEFAULT NULL,
  `retention` int(11) DEFAULT NULL,
  `snapshot` varchar(255) DEFAULT NULL,
  `smbversion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`,`status`)
) ENGINE=MyISAM AUTO_INCREMENT=96 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of archive_jobs
-- ----------------------------

-- ----------------------------
-- Table structure for `backup_jobs`
-- ----------------------------
DROP TABLE IF EXISTS `backup_jobs`;
CREATE TABLE `backup_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entry_name` varchar(255) DEFAULT NULL,
  `server` varchar(255) DEFAULT NULL,
  `domain` varchar(255) DEFAULT NULL,
  `share` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `mysql_username` varchar(255) DEFAULT NULL,
  `mysql_password` varchar(255) DEFAULT NULL,
  `scheduled` int(11) DEFAULT NULL,
  `scheduled_interval` varchar(255) DEFAULT NULL,
  `directory` varchar(255) DEFAULT NULL,
  `startdate` timestamp NULL DEFAULT NULL,
  `notification` varchar(255) DEFAULT NULL,
  `retention` int(11) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT '',
  `archive` varchar(255) DEFAULT NULL,
  `encrypt` varchar(255) DEFAULT NULL,
  `smbversion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`,`status`)
) ENGINE=MyISAM AUTO_INCREMENT=124 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of backup_jobs
-- ----------------------------

-- ----------------------------
-- Table structure for `body_temp`
-- ----------------------------
DROP TABLE IF EXISTS `body_temp`;
CREATE TABLE `body_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `quar_loc` varbinary(255) DEFAULT NULL,
  `customtrans` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=327810 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of body_temp
-- ----------------------------

-- ----------------------------
-- Table structure for `ca_settings`
-- ----------------------------
DROP TABLE IF EXISTS `ca_settings`;
CREATE TABLE `ca_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `validity` varchar(255) DEFAULT NULL,
  `expires` date DEFAULT NULL,
  `encryption` varchar(255) DEFAULT NULL,
  `algorithm` varchar(255) DEFAULT NULL,
  `ca_commonname` varchar(255) DEFAULT NULL,
  `ca_email` varchar(255) DEFAULT NULL,
  `subca_commonname` varchar(255) DEFAULT NULL,
  `subca_email` varchar(255) DEFAULT NULL,
  `organizationname` varchar(255) DEFAULT NULL,
  `unitname` varchar(255) DEFAULT NULL,
  `stateprovincename` varchar(255) DEFAULT NULL,
  `countryname` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  `default2` int(11) DEFAULT NULL,
  `ca_directory` varchar(255) DEFAULT NULL,
  `ca_djigzo_id` int(11) DEFAULT NULL,
  `ca_djigzo_subject` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=45 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of ca_settings
-- ----------------------------
INSERT INTO `ca_settings` VALUES ('44', '1825', '2023-12-03', '4096', null, 'Hermes SEG Root CA', null, null, null, 'Hermes SEG', 'IT', 'Delaware', 'US', null, '2', '1', 'HermesSEGRootCA', '488', 'CN=Hermes SEG Root CA, OU=Hermes SEG, O=IT, ST=Delaware, C=US');

-- ----------------------------
-- Table structure for `captcha_list`
-- ----------------------------
DROP TABLE IF EXISTS `captcha_list`;
CREATE TABLE `captcha_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `random_letter` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=136 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of captcha_list
-- ----------------------------
INSERT INTO `captcha_list` VALUES ('27', 'A         ');
INSERT INTO `captcha_list` VALUES ('28', 'B         ');
INSERT INTO `captcha_list` VALUES ('29', 'C         ');
INSERT INTO `captcha_list` VALUES ('30', 'D         ');
INSERT INTO `captcha_list` VALUES ('31', 'E         ');
INSERT INTO `captcha_list` VALUES ('32', 'F         ');
INSERT INTO `captcha_list` VALUES ('33', 'G         ');
INSERT INTO `captcha_list` VALUES ('34', 'H         ');
INSERT INTO `captcha_list` VALUES ('36', 'J         ');
INSERT INTO `captcha_list` VALUES ('37', 'K         ');
INSERT INTO `captcha_list` VALUES ('38', 'L         ');
INSERT INTO `captcha_list` VALUES ('39', 'M         ');
INSERT INTO `captcha_list` VALUES ('40', 'N         ');
INSERT INTO `captcha_list` VALUES ('42', 'P         ');
INSERT INTO `captcha_list` VALUES ('43', 'Q         ');
INSERT INTO `captcha_list` VALUES ('44', 'R         ');
INSERT INTO `captcha_list` VALUES ('45', 'S         ');
INSERT INTO `captcha_list` VALUES ('46', 'T         ');
INSERT INTO `captcha_list` VALUES ('47', 'U         ');
INSERT INTO `captcha_list` VALUES ('48', 'V         ');
INSERT INTO `captcha_list` VALUES ('49', 'W         ');
INSERT INTO `captcha_list` VALUES ('50', 'X         ');
INSERT INTO `captcha_list` VALUES ('51', 'Y         ');
INSERT INTO `captcha_list` VALUES ('52', 'Z         ');
INSERT INTO `captcha_list` VALUES ('54', '2         ');
INSERT INTO `captcha_list` VALUES ('55', '3         ');
INSERT INTO `captcha_list` VALUES ('56', '4         ');
INSERT INTO `captcha_list` VALUES ('57', '5         ');
INSERT INTO `captcha_list` VALUES ('58', '6         ');
INSERT INTO `captcha_list` VALUES ('59', '7         ');
INSERT INTO `captcha_list` VALUES ('60', '8         ');
INSERT INTO `captcha_list` VALUES ('61', '9         ');
INSERT INTO `captcha_list` VALUES ('93', '1');
INSERT INTO `captcha_list` VALUES ('94', '?');
INSERT INTO `captcha_list` VALUES ('95', '!');
INSERT INTO `captcha_list` VALUES ('96', '$');
INSERT INTO `captcha_list` VALUES ('97', '@');
INSERT INTO `captcha_list` VALUES ('98', '*');
INSERT INTO `captcha_list` VALUES ('101', '%');
INSERT INTO `captcha_list` VALUES ('102', 'a');
INSERT INTO `captcha_list` VALUES ('103', 'b');
INSERT INTO `captcha_list` VALUES ('104', 'c');
INSERT INTO `captcha_list` VALUES ('105', 'd');
INSERT INTO `captcha_list` VALUES ('106', 'e');
INSERT INTO `captcha_list` VALUES ('107', 'f');
INSERT INTO `captcha_list` VALUES ('108', 'g');
INSERT INTO `captcha_list` VALUES ('109', 'h');
INSERT INTO `captcha_list` VALUES ('110', 'i');
INSERT INTO `captcha_list` VALUES ('111', 'j');
INSERT INTO `captcha_list` VALUES ('112', 'k');
INSERT INTO `captcha_list` VALUES ('113', 'l');
INSERT INTO `captcha_list` VALUES ('114', 'm');
INSERT INTO `captcha_list` VALUES ('115', 'n');
INSERT INTO `captcha_list` VALUES ('116', 'o');
INSERT INTO `captcha_list` VALUES ('117', 'p');
INSERT INTO `captcha_list` VALUES ('118', 'q');
INSERT INTO `captcha_list` VALUES ('119', 'r');
INSERT INTO `captcha_list` VALUES ('120', 's');
INSERT INTO `captcha_list` VALUES ('121', 't');
INSERT INTO `captcha_list` VALUES ('122', 'u');
INSERT INTO `captcha_list` VALUES ('123', 'v');
INSERT INTO `captcha_list` VALUES ('124', 'w');
INSERT INTO `captcha_list` VALUES ('125', 'x');
INSERT INTO `captcha_list` VALUES ('126', 'y');
INSERT INTO `captcha_list` VALUES ('127', 'z');
INSERT INTO `captcha_list` VALUES ('128', '?');
INSERT INTO `captcha_list` VALUES ('129', '!');
INSERT INTO `captcha_list` VALUES ('130', '$');
INSERT INTO `captcha_list` VALUES ('131', '@');
INSERT INTO `captcha_list` VALUES ('132', '*');
INSERT INTO `captcha_list` VALUES ('135', '%');

-- ----------------------------
-- Table structure for `captcha_list_all2`
-- ----------------------------
DROP TABLE IF EXISTS `captcha_list_all2`;
CREATE TABLE `captcha_list_all2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `random_letter` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=93 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of captcha_list_all2
-- ----------------------------
INSERT INTO `captcha_list_all2` VALUES ('27', 'A         ');
INSERT INTO `captcha_list_all2` VALUES ('28', 'B         ');
INSERT INTO `captcha_list_all2` VALUES ('29', 'C         ');
INSERT INTO `captcha_list_all2` VALUES ('30', 'D         ');
INSERT INTO `captcha_list_all2` VALUES ('31', 'E         ');
INSERT INTO `captcha_list_all2` VALUES ('32', 'F         ');
INSERT INTO `captcha_list_all2` VALUES ('33', 'G         ');
INSERT INTO `captcha_list_all2` VALUES ('34', 'H         ');
INSERT INTO `captcha_list_all2` VALUES ('36', 'J         ');
INSERT INTO `captcha_list_all2` VALUES ('37', 'K         ');
INSERT INTO `captcha_list_all2` VALUES ('38', 'L         ');
INSERT INTO `captcha_list_all2` VALUES ('39', 'M         ');
INSERT INTO `captcha_list_all2` VALUES ('40', 'N         ');
INSERT INTO `captcha_list_all2` VALUES ('42', 'P         ');
INSERT INTO `captcha_list_all2` VALUES ('43', 'Q         ');
INSERT INTO `captcha_list_all2` VALUES ('44', 'R         ');
INSERT INTO `captcha_list_all2` VALUES ('45', 'S         ');
INSERT INTO `captcha_list_all2` VALUES ('46', 'T         ');
INSERT INTO `captcha_list_all2` VALUES ('47', 'U         ');
INSERT INTO `captcha_list_all2` VALUES ('48', 'V         ');
INSERT INTO `captcha_list_all2` VALUES ('49', 'W         ');
INSERT INTO `captcha_list_all2` VALUES ('50', 'X         ');
INSERT INTO `captcha_list_all2` VALUES ('51', 'Y         ');
INSERT INTO `captcha_list_all2` VALUES ('52', 'Z         ');
INSERT INTO `captcha_list_all2` VALUES ('53', '1         ');
INSERT INTO `captcha_list_all2` VALUES ('54', '2         ');
INSERT INTO `captcha_list_all2` VALUES ('55', '3         ');
INSERT INTO `captcha_list_all2` VALUES ('56', '4         ');
INSERT INTO `captcha_list_all2` VALUES ('57', '5         ');
INSERT INTO `captcha_list_all2` VALUES ('58', '6         ');
INSERT INTO `captcha_list_all2` VALUES ('59', '7         ');
INSERT INTO `captcha_list_all2` VALUES ('60', '8         ');
INSERT INTO `captcha_list_all2` VALUES ('61', '9         ');
INSERT INTO `captcha_list_all2` VALUES ('62', 'a');
INSERT INTO `captcha_list_all2` VALUES ('63', 'b');
INSERT INTO `captcha_list_all2` VALUES ('64', 'c');
INSERT INTO `captcha_list_all2` VALUES ('65', 'd');
INSERT INTO `captcha_list_all2` VALUES ('66', 'e');
INSERT INTO `captcha_list_all2` VALUES ('67', 'f');
INSERT INTO `captcha_list_all2` VALUES ('68', 'g');
INSERT INTO `captcha_list_all2` VALUES ('69', 'h');
INSERT INTO `captcha_list_all2` VALUES ('70', 'i');
INSERT INTO `captcha_list_all2` VALUES ('71', 'j');
INSERT INTO `captcha_list_all2` VALUES ('72', 'k');
INSERT INTO `captcha_list_all2` VALUES ('73', 'l');
INSERT INTO `captcha_list_all2` VALUES ('74', 'm');
INSERT INTO `captcha_list_all2` VALUES ('75', 'n');
INSERT INTO `captcha_list_all2` VALUES ('76', 'o');
INSERT INTO `captcha_list_all2` VALUES ('77', 'p');
INSERT INTO `captcha_list_all2` VALUES ('78', 'q');
INSERT INTO `captcha_list_all2` VALUES ('79', 'r');
INSERT INTO `captcha_list_all2` VALUES ('80', 's');
INSERT INTO `captcha_list_all2` VALUES ('81', 't');
INSERT INTO `captcha_list_all2` VALUES ('82', 'u');
INSERT INTO `captcha_list_all2` VALUES ('83', 'v');
INSERT INTO `captcha_list_all2` VALUES ('84', 'w');
INSERT INTO `captcha_list_all2` VALUES ('85', 'y');
INSERT INTO `captcha_list_all2` VALUES ('86', 'z');

-- ----------------------------
-- Table structure for `captcha_list_all3`
-- ----------------------------
DROP TABLE IF EXISTS `captcha_list_all3`;
CREATE TABLE `captcha_list_all3` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `random_letter` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=94 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of captcha_list_all3
-- ----------------------------
INSERT INTO `captcha_list_all3` VALUES ('53', '1         ');
INSERT INTO `captcha_list_all3` VALUES ('54', '2         ');
INSERT INTO `captcha_list_all3` VALUES ('55', '3         ');
INSERT INTO `captcha_list_all3` VALUES ('56', '4         ');
INSERT INTO `captcha_list_all3` VALUES ('57', '5         ');
INSERT INTO `captcha_list_all3` VALUES ('58', '6         ');
INSERT INTO `captcha_list_all3` VALUES ('59', '7         ');
INSERT INTO `captcha_list_all3` VALUES ('60', '8         ');
INSERT INTO `captcha_list_all3` VALUES ('61', '9         ');
INSERT INTO `captcha_list_all3` VALUES ('62', 'a');
INSERT INTO `captcha_list_all3` VALUES ('63', 'b');
INSERT INTO `captcha_list_all3` VALUES ('64', 'c');
INSERT INTO `captcha_list_all3` VALUES ('65', 'd');
INSERT INTO `captcha_list_all3` VALUES ('66', 'e');
INSERT INTO `captcha_list_all3` VALUES ('67', 'f');
INSERT INTO `captcha_list_all3` VALUES ('93', '0');

-- ----------------------------
-- Table structure for `clients`
-- ----------------------------
DROP TABLE IF EXISTS `clients`;
CREATE TABLE `clients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `client` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of clients
-- ----------------------------
INSERT INTO `clients` VALUES ('1', '82.76.154.20', 'REJECT');
INSERT INTO `clients` VALUES ('7', '82.76', 'REJECT');
INSERT INTO `clients` VALUES ('8', '84.122', 'REJECT');
INSERT INTO `clients` VALUES ('9', '95.76', 'REJECT');
INSERT INTO `clients` VALUES ('10', '77.49', 'REJECT');
INSERT INTO `clients` VALUES ('11', 'registrar-servers.com', 'REJECT');
INSERT INTO `clients` VALUES ('12', 'rotary.org', 'ACCEPT');

-- ----------------------------
-- Table structure for `command`
-- ----------------------------
DROP TABLE IF EXISTS `command`;
CREATE TABLE `command` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `command` blob,
  `trans_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3294 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of command
-- ----------------------------

-- ----------------------------
-- Table structure for `configuration`
-- ----------------------------
DROP TABLE IF EXISTS `configuration`;
CREATE TABLE `configuration` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conf` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `module` varchar(255) DEFAULT NULL,
  `default_value` varchar(255) DEFAULT NULL,
  `default2` int(11) DEFAULT NULL,
  `order1` int(11) DEFAULT NULL,
  `order2` int(11) DEFAULT NULL,
  `parent` int(11) DEFAULT NULL,
  `parent2` int(11) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `enabled` int(11) DEFAULT NULL,
  `editable` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of configuration
-- ----------------------------
INSERT INTO `configuration` VALUES ('1', 'main.cf', 'message_size_limit', '52428800', 'postfix', '10485760', '1', '1', null, null, null, 'Message size limit in megabytes (MB)', '1', '1');
INSERT INTO `configuration` VALUES ('2', 'main.cf', 'myorigin', 'deeztek.com', 'postfix', 'domain.tld', '1', '1', null, '2', null, 'Your domain name (domain.tld)', '1', '1');
INSERT INTO `configuration` VALUES ('3', 'main.cf', 'myhostname', 'smtp.deeztek.com', 'postfix', 'hermes.domain.tld', '1', '1', null, '2', null, 'Your server name (host.domain.tld)', '1', '1');
INSERT INTO `configuration` VALUES ('4', 'main.cf', 'mynetworks', '127.0.0.1', 'postfix', '127.0.0.1', '1', '1', '1', '2', null, null, '1', '2');
INSERT INTO `configuration` VALUES ('5', 'main.cf', 'smtpd_helo_required', 'yes', 'postfix', 'yes', '1', '1', null, null, null, 'Require helo command for incoming connections', '1', '1');
INSERT INTO `configuration` VALUES ('6', 'main.cf', 'smtpd_sender_restrictions', 'check_sender_access mysql:/etc/postfix/mysql-senders.cf', 'postfix', 'check_sender_access mysql:/etc/postfix/mysql-senders.cf', '1', '1', null, null, null, 'Check email senders access list', '1', '2');
INSERT INTO `configuration` VALUES ('7', 'main.cf', 'mynetworks', '192.168.10.0/24', 'postfix', '', '2', '1', '2', null, null, null, '1', '1');
INSERT INTO `configuration` VALUES ('8', 'main.cf', 'mynetworks', '74.92.146.137', 'postfix', null, '2', '1', '3', null, null, null, '1', '1');
INSERT INTO `configuration` VALUES ('9', 'main.cf', 'mynetworks', '24.154.92.8', 'postfix', null, '2', '1', '4', null, null, null, '1', '1');
INSERT INTO `configuration` VALUES ('10', 'main.cf', 'mynetworks', '173.8.28.13', 'postfix', null, '2', '1', '5', null, null, null, '1', '1');
INSERT INTO `configuration` VALUES ('11', 'main.cf', 'mynetworks', '71.248.99.112', 'postfix', null, '2', '1', '6', null, null, null, '1', '1');
INSERT INTO `configuration` VALUES ('12', 'main.cf', 'smtpd_sender_restrictions', 'reject_non_fqdn_sender', 'postfix', 'reject_non_fqdn_sender', '1', '2', '2', null, null, 'Reject email senders without fully qualified domain names (FQDN)', '1', '1');
INSERT INTO `configuration` VALUES ('13', 'main.cf', 'smtpd_sender_restrictions', 'reject_unknown_sender_domain', 'postfix', 'reject_unknown_sender_domain', '1', '3', '3', null, null, 'Reject email senders with invalid domain names', '1', '1');
INSERT INTO `configuration` VALUES ('14', 'main.cf', 'smtpd_recipient_restrictions', 'permit_mynetworks', 'postfix', 'permit_mynetworks', '1', '1', '1', null, null, 'Permit hosts appearing in My Networks list to send email', '1', '2');
INSERT INTO `configuration` VALUES ('15', 'main.cf', 'smtpd_recipient_restrictions', 'reject_unauth_destination', 'postfix', 'reject_unauth_destination', '1', '2', '2', null, null, 'Reject email going to invalid destinations', '1', '2');
INSERT INTO `configuration` VALUES ('16', 'main.cf', 'smtpd_recipient_restrictions', 'reject_unauth_pipelining', 'postfix', 'reject_unauth_pipelining', '1', '4', '4', null, null, 'Reject pipelined email', '1', '1');
INSERT INTO `configuration` VALUES ('17', 'main.cf', 'smtpd_recipient_restrictions', 'check_policy_service unix:private/policy-spf', 'postfix', 'smtpd_recipient_restrictions', '2', '3', '5', null, null, 'Enable sender policy framework (SPF)', '1', '1');
INSERT INTO `configuration` VALUES ('18', 'main.cf', 'smtpd_recipient_restrictions', 'reject_rbl_client zombie.dnsbl.sorbs.net', 'postfix', 'reject_rbl_client zombie.dnsbl.sorbs.net', '2', '5', '6', null, null, 'Enable sorbs blacklist', '2', '1');
INSERT INTO `configuration` VALUES ('19', 'main.cf', 'smtpd_recipient_restrictions', 'reject_rbl_client sbl.spamhaus.org', 'postfix', 'reject_rbl_client sbl.spamhaus.org', '2', '5', '7', null, null, 'Enable spamhaus blacklist', '1', '1');
INSERT INTO `configuration` VALUES ('20', 'main.cf', 'smtpd_recipient_restrictions', 'reject_rbl_client blackholes.mail-abuse.org', 'postfix', 'reject_rbl_client blackholes.mail-abuse.org', '2', '5', '8', null, null, 'Enable mail-abuse.org blacklist', '2', '1');
INSERT INTO `configuration` VALUES ('21', 'main.cf', 'smtpd_recipient_restrictions', 'check_policy_service inet:127.0.0.1:10023', 'postfix', 'smtpd_recipient_restrictions', '2', '6', '9', null, null, 'Enable greylisting (5 Minute Delay)', '1', '1');
INSERT INTO `configuration` VALUES ('22', 'main.cf', 'smtpd_recipient_restrictions', 'reject_rbl_client bl.spamcop.net', 'postfix', 'reject_rbl_client bl.spamcop.net', '2', '5', '10', null, null, 'Enable spamcop blacklist', '1', '1');
INSERT INTO `configuration` VALUES ('23', 'main.cf', 'smtpd_recipient_restrictions', 'reject_rbl_client cbl.abuseat.org', 'postfix', 'reject_rbl_client cbl.abuseat.org', '2', '5', '11', null, null, 'Enable abuseat.org blacklist', '1', '1');
INSERT INTO `configuration` VALUES ('24', 'main.cf', 'smtpd_recipient_restrictions', 'reject_rbl_client dnsbl.njabl.org', 'postfix', 'reject_rbl_client dnsbl.njabl.org', '2', '5', '12', null, null, 'Enable njabl.org blacklist', '1', '1');

-- ----------------------------
-- Table structure for `dkim_bypass`
-- ----------------------------
DROP TABLE IF EXISTS `dkim_bypass`;
CREATE TABLE `dkim_bypass` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entry` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of dkim_bypass
-- ----------------------------

-- ----------------------------
-- Table structure for `dkim_sign`
-- ----------------------------
DROP TABLE IF EXISTS `dkim_sign`;
CREATE TABLE `dkim_sign` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(255) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  `public` varchar(255) DEFAULT NULL,
  `private` varchar(255) DEFAULT NULL,
  `enabled` int(11) DEFAULT NULL,
  `generated` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=207 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of dkim_sign
-- ----------------------------
INSERT INTO `dkim_sign` VALUES ('200', 'deeztek.com', '1', 'deeztek.com.dkim.txt', 'deeztek.com.dkim.private', '1', '1');
INSERT INTO `dkim_sign` VALUES ('202', 'mydirectmail.net', '1', 'mydirectmail.net.dkim.txt', 'mydirectmail.net.dkim.private', '1', '1');
INSERT INTO `dkim_sign` VALUES ('203', 'eickelberger.org', '1', 'eickelberger.org.dkim.txt', 'eickelberger.org.dkim.private', '1', '1');
INSERT INTO `dkim_sign` VALUES ('204', 'excoffee.com', '1', 'excoffee.com.dkim.txt', 'excoffee.com.dkim.private', '1', '1');

-- ----------------------------
-- Table structure for `dkim_trusted_hosts`
-- ----------------------------
DROP TABLE IF EXISTS `dkim_trusted_hosts`;
CREATE TABLE `dkim_trusted_hosts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `host` varchar(255) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=196 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of dkim_trusted_hosts
-- ----------------------------

-- ----------------------------
-- Table structure for `domains`
-- ----------------------------
DROP TABLE IF EXISTS `domains`;
CREATE TABLE `domains` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(255) DEFAULT NULL,
  `policy_id` int(11) DEFAULT NULL,
  `transport_id` int(11) DEFAULT NULL,
  `senders_id` int(11) DEFAULT NULL,
  `action_taken` varchar(255) DEFAULT NULL,
  `recipients_id` int(11) DEFAULT NULL,
  `default` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=456 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of domains
-- ----------------------------
INSERT INTO `domains` VALUES ('455', 'domain.tld', null, '366', '412', 'OK', '1480', null, null);

-- ----------------------------
-- Table structure for `domains_temp`
-- ----------------------------
DROP TABLE IF EXISTS `domains_temp`;
CREATE TABLE `domains_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(255) DEFAULT NULL,
  `policy_id` int(11) DEFAULT NULL,
  `transport_id` int(11) DEFAULT NULL,
  `senders_id` int(11) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `domain_id` int(11) DEFAULT NULL,
  `transport` varchar(255) DEFAULT NULL,
  `destination` varchar(255) DEFAULT NULL,
  `recipients_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=443 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of domains_temp
-- ----------------------------

-- ----------------------------
-- Table structure for `encrypted_recipients`
-- ----------------------------
DROP TABLE IF EXISTS `encrypted_recipients`;
CREATE TABLE `encrypted_recipients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `policy_id` int(11) DEFAULT NULL,
  `recipient` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `pdf_enabled` int(11) DEFAULT NULL,
  `smime_enabled` int(11) DEFAULT NULL,
  `smime_mode` int(11) DEFAULT NULL,
  `smime_certificate_name` varchar(255) DEFAULT NULL,
  `digital_sign` int(11) DEFAULT NULL,
  `pfx_certificate_name` varchar(255) DEFAULT NULL,
  `smime_certificate_password` varchar(255) DEFAULT NULL,
  `smime_certificate_expiration` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  `validity` varchar(255) NOT NULL,
  `encryption` varchar(255) NOT NULL,
  `algorithm` varchar(255) NOT NULL,
  `ca_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=456 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of encrypted_recipients
-- ----------------------------

-- ----------------------------
-- Table structure for `encryption_settings`
-- ----------------------------
DROP TABLE IF EXISTS `encryption_settings`;
CREATE TABLE `encryption_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `alias` varchar(255) DEFAULT NULL,
  `property` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=624 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of encryption_settings
-- ----------------------------
INSERT INTO `encryption_settings` VALUES ('614', 'subjectenable', 'user.subjectTriggerEnabled', 'true');
INSERT INTO `encryption_settings` VALUES ('615', 'subject_trigger', 'user.subjectTrigger', '[encrypt]');
INSERT INTO `encryption_settings` VALUES ('616', 'encryptreceipt', 'user.sendEncryptionNotification', 'true');
INSERT INTO `encryption_settings` VALUES ('617', 'portal_url', 'user.portal.baseURL', 'https://hermes.domain.tld:9080/web/portal');
INSERT INTO `encryption_settings` VALUES ('618', 'pdfreply_sender', 'user.pdf.replySender', 'postmaster@domain.tld');
INSERT INTO `encryption_settings` VALUES ('619', 'removesubjecttrigger', 'user.subjectTriggerRemovePattern', 'true');
INSERT INTO `encryption_settings` VALUES ('621', 'serverkeyword', 'user.serverSecret', '');
INSERT INTO `encryption_settings` VALUES ('622', 'clientkeyword', 'user.clientSecret', '');
INSERT INTO `encryption_settings` VALUES ('623', 'mailkeyword', 'user.systemMailSecret', '');

-- ----------------------------
-- Table structure for `external_recipient_certificates`
-- ----------------------------
DROP TABLE IF EXISTS `external_recipient_certificates`;
CREATE TABLE `external_recipient_certificates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `smime_certificate_key` varchar(255) DEFAULT NULL,
  `external_ca` int(11) DEFAULT NULL,
  `smime_certificate_request` varchar(255) DEFAULT NULL,
  `smime_certificate_name` varchar(255) DEFAULT NULL,
  `pfx_certificate_name` varchar(255) DEFAULT NULL,
  `smime_certificate_password` varchar(255) DEFAULT NULL,
  `smime_certificate_expiration` date DEFAULT NULL,
  `validity` varchar(255) DEFAULT NULL,
  `encryption` varchar(255) DEFAULT NULL,
  `algorithm` varchar(255) DEFAULT NULL,
  `ca_id` int(11) DEFAULT NULL,
  `serial` varchar(255) DEFAULT NULL,
  `external_ca_name` varchar(255) DEFAULT NULL,
  `thumbprint` varchar(255) DEFAULT NULL,
  `djigzo_certificate_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=33 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of external_recipient_certificates
-- ----------------------------

-- ----------------------------
-- Table structure for `external_recipients`
-- ----------------------------
DROP TABLE IF EXISTS `external_recipients`;
CREATE TABLE `external_recipients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `smime` int(255) DEFAULT NULL,
  `pdf` int(11) DEFAULT NULL,
  `pdf_mode` varchar(255) DEFAULT NULL,
  `smime_mode` varchar(255) DEFAULT NULL,
  `encryption_mode` varchar(255) DEFAULT NULL,
  `pdf_password` varchar(255) DEFAULT NULL,
  `pgp` int(255) DEFAULT NULL,
  `pgp_mode` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=184 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of external_recipients
-- ----------------------------

-- ----------------------------
-- Table structure for `fetchmail`
-- ----------------------------
DROP TABLE IF EXISTS `fetchmail`;
CREATE TABLE `fetchmail` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `remote_server` varchar(255) DEFAULT NULL,
  `protocol` varchar(255) DEFAULT NULL,
  `port` int(11) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `local_recipient` varchar(255) DEFAULT NULL,
  `headers` varchar(255) DEFAULT NULL,
  `keep` varchar(255) DEFAULT NULL,
  `fetchall` varchar(255) DEFAULT NULL,
  `incoming_server` varchar(255) DEFAULT NULL,
  `encryption` varchar(255) DEFAULT NULL,
  `encryption_protocol` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of fetchmail
-- ----------------------------
INSERT INTO `fetchmail` VALUES ('2', 'mail.google.com', 'auto', null, 'ru2n4m', 'ddfasdfasdfasdf', '', 'no', 'yes', 'no', null, 'yes', 'auto');
INSERT INTO `fetchmail` VALUES ('3', 'mail.google.com', 'auto', null, 'ru2n4m', 'ddfasdfasdfasdf', '', 'no', 'yes', 'no', null, 'yes', 'auto');
INSERT INTO `fetchmail` VALUES ('4', 'mail.google.com', 'auto', null, 'ru2n4m', 'ddfasdfasdfasdf', 'administrator@firstmd.org', 'no', 'yes', 'no', null, 'yes', 'auto');
INSERT INTO `fetchmail` VALUES ('5', 'mail.google.com', 'auto', null, 'ru2n4m', 'ddfasdfasdfasdf', 'dino.edwards@mydirectmail.net', 'no', 'yes', 'no', null, 'yes', 'auto');
INSERT INTO `fetchmail` VALUES ('6', 'mail.google.com', 'POP3', null, 'ru2n4m', 'ddfasdfasdfasdf', 'administrator@firstmd.org', 'no', 'yes', 'no', null, 'yes', 'TLS1');
INSERT INTO `fetchmail` VALUES ('7', 'mail.google.com', 'IMAP', null, 'ru2n4m', 'ddfasdfasdfasdf', 'administrator@firstmd.org', 'yes', 'no', 'no', null, 'yes', 'SSL3');

-- ----------------------------
-- Table structure for `file_rule_components`
-- ----------------------------
DROP TABLE IF EXISTS `file_rule_components`;
CREATE TABLE `file_rule_components` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_id` int(11) DEFAULT NULL,
  `rule_id` int(11) DEFAULT NULL,
  `rule_name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2374 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of file_rule_components
-- ----------------------------
INSERT INTO `file_rule_components` VALUES ('589', '3', '5', 'Default', '(.pif) Program Information File', null, 'ban', '8', '1');
INSERT INTO `file_rule_components` VALUES ('588', '2', '5', 'Default', '(.vbs) Visual Basic Script', null, 'ban', '7', '1');
INSERT INTO `file_rule_components` VALUES ('587', '1', '5', 'Default', '(.exe) Executable', null, 'ban', '6', '1');
INSERT INTO `file_rule_components` VALUES ('586', '43', '5', 'Default', '(application/hta) Microsoft HTML Application', null, 'ban', '5', '1');
INSERT INTO `file_rule_components` VALUES ('585', '45', '5', 'Default', '(application/x-msdos-program) MS DOS application and executable', null, 'ban', '4', '1');
INSERT INTO `file_rule_components` VALUES ('584', '44', '5', 'Default', '(application/x-msdownload) Windows  DLL and EXE', null, 'ban', '3', '1');
INSERT INTO `file_rule_components` VALUES ('582', '93', '5', 'Default', 'Double Extensions in File Name (exe,vbs,pif,scr,bat,cmd,com,cpl,dll,rtf)', null, 'ban', '1', '1');
INSERT INTO `file_rule_components` VALUES ('583', '49', '5', 'Default', 'Windows Class IDs', null, 'ban', '2', '1');
INSERT INTO `file_rule_components` VALUES ('581', '4', '5', 'Default', '(.scr) Windows Screensaver File', null, 'ban', '9', '1');
INSERT INTO `file_rule_components` VALUES ('579', '7', '5', 'Default', '(.cmd) Batch File', null, 'ban', '11', '1');
INSERT INTO `file_rule_components` VALUES ('580', '6', '5', 'Default', '(.bat) Batch File', null, 'ban', '10', '1');
INSERT INTO `file_rule_components` VALUES ('578', '8', '5', 'Default', '(.com) MS-DOS Binary Format', null, 'ban', '12', '1');
INSERT INTO `file_rule_components` VALUES ('577', '9', '5', 'Default', '(.cpl) Windows Control Panel', null, 'ban', '13', '1');
INSERT INTO `file_rule_components` VALUES ('576', '11', '5', 'Default', '(.rtf) Rich Text Format ', null, 'ban', '14', '1');
INSERT INTO `file_rule_components` VALUES ('575', '91', '5', 'Default', '(dll) Windows Dynamic Link Library (File Type)', null, 'ban', '16', '1');
INSERT INTO `file_rule_components` VALUES ('574', '25', '5', 'Default', '(exe-ms) Microsoft Executables', null, 'ban', '15', '1');
INSERT INTO `file_rule_components` VALUES ('573', '88', '5', 'Default', '(lha) Compressed Archive File', null, 'ban', '17', '1');
INSERT INTO `file_rule_components` VALUES ('572', '90', '5', 'Default', '(cab) Cabinet File', null, 'ban', '20', '1');
INSERT INTO `file_rule_components` VALUES ('571', '89', '5', 'Default', '(tnef) Transport Neutral Encapsulated Format File', null, 'ban', '19', '1');
INSERT INTO `file_rule_components` VALUES ('570', '94', '5', 'Default', '(exe) Executable (File Type)', null, 'ban', '18', '1');

-- ----------------------------
-- Table structure for `file_rule_components_temp`
-- ----------------------------
DROP TABLE IF EXISTS `file_rule_components_temp`;
CREATE TABLE `file_rule_components_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_id` int(11) DEFAULT NULL,
  `rule_id` int(11) DEFAULT NULL,
  `rule_name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `sessionno` varchar(255) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=4794 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of file_rule_components_temp
-- ----------------------------

-- ----------------------------
-- Table structure for `file_rules`
-- ----------------------------
DROP TABLE IF EXISTS `file_rules`;
CREATE TABLE `file_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule_id` int(11) DEFAULT NULL,
  `rule_name` varchar(255) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of file_rules
-- ----------------------------
INSERT INTO `file_rules` VALUES ('1', '3', 'SYSTEM_DEFAULT', '1');

-- ----------------------------
-- Table structure for `file_types`
-- ----------------------------
DROP TABLE IF EXISTS `file_types`;
CREATE TABLE `file_types` (
  `name` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of file_types
-- ----------------------------
INSERT INTO `file_types` VALUES ('EXT', 'File Extension');
INSERT INTO `file_types` VALUES ('EXT-HIGH', 'High Risk File Extension');
INSERT INTO `file_types` VALUES ('FILE', 'File Type');
INSERT INTO `file_types` VALUES ('FILE-HIGH', 'High Risk File Type');
INSERT INTO `file_types` VALUES ('MIME', 'MIME-Type');
INSERT INTO `file_types` VALUES ('MIME-HIGH', 'High Risk MIME-Type');

-- ----------------------------
-- Table structure for `files`
-- ----------------------------
DROP TABLE IF EXISTS `files`;
CREATE TABLE `files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `system` char(255) DEFAULT NULL,
  `allow` varchar(255) DEFAULT NULL,
  `ban` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`,`file`)
) ENGINE=MyISAM AUTO_INCREMENT=118 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of files
-- ----------------------------
INSERT INTO `files` VALUES ('1', 'exe', '(.exe) Executable (File Extension)', 'EXT-HIGH', 'YES', '[qr\'.\\.(exe)$\'i => 0]', '[qr\'.\\.(exe)$\'i => 1]');
INSERT INTO `files` VALUES ('2', 'vbs', '(.vbs) Visual Basic Script', 'EXT-HIGH', 'YES', '[qr\'.\\.(vbs)$\'i => 0]', '[qr\'.\\.(vbs)$\'i => 1]');
INSERT INTO `files` VALUES ('3', 'pif', '(.pif) Program Information File', 'EXT-HIGH', 'YES', '[qr\'.\\.(pif)$\'i => 0]', '[qr\'.\\.(pif)$\'i => 1]');
INSERT INTO `files` VALUES ('4', 'scr', '(.scr) Windows Screensaver File', 'EXT-HIGH', 'YES', '[qr\'.\\.(scr)$\'i => 0]', '[qr\'.\\.(scr)$\'i => 1]');
INSERT INTO `files` VALUES ('6', 'bat', '(.bat) Batch File', 'EXT-HIGH', 'YES', '[qr\'.\\.(bat)$\'i => 0]', '[qr\'.\\.(bat)$\'i => 1]');
INSERT INTO `files` VALUES ('7', 'cmd', '(.cmd) Batch File', 'EXT-HIGH', 'YES', '[qr\'.\\.(cmd)$\'i => 0]', '[qr\'.\\.(cmd)$\'i => 1]');
INSERT INTO `files` VALUES ('8', 'com', '(.com) MS-DOS Binary Format', 'EXT-HIGH', 'YES', '[qr\'.\\.(com)$\'i => 0]', '[qr\'.\\.(com)$\'i => 1]');
INSERT INTO `files` VALUES ('9', 'cpl', '(.cpl) Windows Control Panel', 'EXT-HIGH', 'YES', '[qr\'.\\.(cpl)$\'i => 0]', '[qr\'.\\.(cpl)$\'i => 1]');
INSERT INTO `files` VALUES ('11', 'rtf', '(.rtf) Rich Text Format ', 'EXT-HIGH', 'YES', '[qr\'.\\.(rtf)$\'i => 0]', '[qr\'.\\.(rtf)$\'i => 1]');
INSERT INTO `files` VALUES ('15', 'gz', '(.gz) Unix-compressed', 'EXT', 'YES', '[qr\'^\\.(gz)$\'i => 0]', '[qr\'^\\.(gz)$\'i => 1]');
INSERT INTO `files` VALUES ('16', 'bz2', '(.bz2) Unix-compressed', 'EXT', 'YES', '[qr\'^\\.(bz2)$\'i => 0]', '[qr\'^\\.(bz2)$\'i => 1]');
INSERT INTO `files` VALUES ('17', 'rpm', '(.rpm) Unix-type archive', 'EXT', 'YES', '[qr\'^\\.(rpm)$\'i => 0]', '[qr\'^\\.(rpm)$\'i => 1]');
INSERT INTO `files` VALUES ('18', 'cpio', '(.cpio) Unix-type archive', 'EXT', 'YES', '[qr\'^\\.(cpio)$\'i => 0]', '[qr\'^\\.(cpio)$\'i => 1]');
INSERT INTO `files` VALUES ('19', 'tar', '(.tar) Unix-type archive', 'EXT', 'YES', '[qr\'^\\.(tar)$\'i => 0]', '[qr\'^\\.(tar)$\'i => 1]');
INSERT INTO `files` VALUES ('20', 'zip', '(.zip) Zip Archive', 'EXT', 'YES', '[qr\'^\\.(zip)$\'i => 0]', '[qr\'^\\.(zip)$\'i => 1]');
INSERT INTO `files` VALUES ('21', 'rar', '(.rar) Rar Archive', 'EXT', 'YES', '[qr\'^\\.(rar)$\'i => 0]', '[qr\'^\\.(rar)$\'i => 1]');
INSERT INTO `files` VALUES ('22', 'arc', '(.arc) Arc Archive', 'EXT', 'YES', '[qr\'^\\.(arc)$\'i => 0]', '[qr\'^\\.(arc)$\'i => 1]');
INSERT INTO `files` VALUES ('23', 'arj', '(.arj) Arj Archive', 'EXT', 'YES', '[qr\'^\\.(arj)$\'i => 0]', '[qr\'^\\.(arj)$\'i => 1]');
INSERT INTO `files` VALUES ('24', 'zoo', '(.zoo) Zoo Archive', 'EXT', 'YES', '[qr\'^\\.(zoo)$\'i => 0]', '[qr\'^\\.(zoo)$\'i => 1]');
INSERT INTO `files` VALUES ('25', 'exe-ms', '(exe-ms) Microsoft Executables', 'FILE-HIGH', 'YES', '[qr\'^\\.(exe-ms)$\' => 0]', '[qr\'^\\.(exe-ms)$\' => 1]');
INSERT INTO `files` VALUES ('26', 'ade', '(.ade) Microsoft Access Project Extension', 'EXT', 'YES', '[qr\'.\\.(ade)$\'ix => 0]', '[qr\'.\\.(ade)$\'ix => 1]');
INSERT INTO `files` VALUES ('27', 'adp', '(.adp) Microsoft Access Project', 'EXT', 'YES', '[qr\'.\\.(adp)$\'ix => 0]', '[qr\'.\\.(adp)$\'ix => 1]');
INSERT INTO `files` VALUES ('28', 'app', '(.app) Mac OS X Application', 'EXT', 'YES', '[qr\'.\\.(app)$\'ix => 0]', '[qr\'.\\.(app)$\'ix => 1]');
INSERT INTO `files` VALUES ('29', 'bas', '(.bas) Microsoft Visual Basic Class Module', 'EXT', 'YES', '[qr\'.\\.(bas)$\'ix => 0]', '[qr\'.\\.(bas)$\'ix => 1]');
INSERT INTO `files` VALUES ('30', 'chm', '(.chm) Microsoft Compiled HTML Help', 'EXT', 'YES', '[qr\'.\\.(chm)$\'ix => 0]', '[qr\'.\\.(chm)$\'ix => 1]');
INSERT INTO `files` VALUES ('31', 'crt', '(.crt) Certificate in PEM Format', 'EXT', 'YES', '[qr\'.\\.(crt)$\'ix => 0]', '[qr\'.\\.(crt)$\'ix => 1]');
INSERT INTO `files` VALUES ('32', 'emf', '(.emf) Enhanced Windows Metafile', 'EXT', 'YES', '[qr\'.\\.(emf)$\'ix => 0]', '[qr\'.\\.(emf)$\'ix => 1]');
INSERT INTO `files` VALUES ('33', 'fxp', '(.fxp) Adobe Flash Catalyst', 'EXT', 'YES', '[qr\'.\\.(fxp)$\'ix => 0]', '[qr\'.\\.(fxp)$\'ix => 1]');
INSERT INTO `files` VALUES ('34', 'grp', '(.grp) Windows Program Manager Group', 'EXT', 'YES', '[qr\'.\\.(grp)$\'ix => 0]', '[qr\'.\\.(grp)$\'ix => 1]');
INSERT INTO `files` VALUES ('35', 'hlp', '(.hlp) Windows Help File', 'EXT', 'YES', '[qr\'.\\.(hlp)$\'ix => 0]', '[qr\'.\\.(hlp)$\'ix => 1]');
INSERT INTO `files` VALUES ('36', 'hta', '(.hta) HTML executable file', 'EXT', 'YES', '[qr\'.\\.(hta)$\'ix => 0]', '[qr\'.\\.(hta)$\'ix => 1]');
INSERT INTO `files` VALUES ('37', 'inf', '(.inf) Windows Setup Information file', 'EXT', 'YES', '[qr\'.\\.(inf)$\'ix => 0]', '[qr\'.\\.(inf)$\'ix => 1]');
INSERT INTO `files` VALUES ('38', 'ins', '(.ins) Windows Internet Naming Service File', 'EXT', 'YES', '[qr\'.\\.(ins)$\'ix => 0]', '[qr\'.\\.(ins)$\'ix => 1]');
INSERT INTO `files` VALUES ('39', 'isp', '(.isp) IIS Internet Service Provider Settings', 'EXT', 'YES', '[qr\'.\\.(isp)$\'ix => 0]', '[qr\'.\\.(isp)$\'ix => 1]');
INSERT INTO `files` VALUES ('40', 'js', '(.js) JavaScript', 'EXT', 'YES', '[qr\'.\\.(js)$\'ix => 0]', '[qr\'.\\.(js)$\'ix => 1]');
INSERT INTO `files` VALUES ('41', 'jse', '(.jse) Fichier Encoded Javascript', 'EXT', 'YES', '[qr\'.\\.(jse)$\'ix => 0]', '[qr\'.\\.(jse)$\'ix => 1]');
INSERT INTO `files` VALUES ('43', 'application/hta', '(application/hta) Microsoft HTML Application', 'MIME-HIGH', 'YES', '[qr\'^application/hta$\'i => 0]', '[qr\'^application/hta$\'i => 1]');
INSERT INTO `files` VALUES ('44', 'application/x-msdownload', '(application/x-msdownload) Windows  DLL and EXE', 'MIME-HIGH', 'YES', '[qr\'^application/x-msdownload$\'i => 0]', '[qr\'^application/x-msdownload$\'i => 1]');
INSERT INTO `files` VALUES ('45', 'application/x-msdos-program', '(application/x-msdos-program) MS DOS application and executable', 'MIME-HIGH', 'YES', '[qr\'^application/x-msdos-program$\'i => 0]', '[qr\'^application/x-msdos-program$\'i => 1]');
INSERT INTO `files` VALUES ('68', 'mda', '(.mda) Microsoft Access Add-in File', 'EXT', 'YES', '[qr\'.\\.(mda)$\'ix => 0]', '[qr\'.\\.(mda)$\'ix => 1]');
INSERT INTO `files` VALUES ('48', 'UNDECIPHERABLE', 'Undecipherable Components', 'OTHER', 'YES', '[qr\'^UNDECIPHERABLE$\' => 0]', '[qr\'^UNDECIPHERABLE$\' => 1]');
INSERT INTO `files` VALUES ('49', '{[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}\\}?', 'Windows Class IDs', 'OTHER', 'YES', '[qr\'\\{[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}\\}?$\'i => 0]', '[qr\'\\{[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}\\}?$\'i => 1]');
INSERT INTO `files` VALUES ('50', 'application/x-msmetafile', '(application/x-msmetafile) Windows Metafile', 'MIME', 'YES', '[qr\'^application/x-msmetafile$\'i => 0]', '[qr\'^application/x-msmetafile$\'i => 1]');
INSERT INTO `files` VALUES ('51', 'wmf', '(.wmf) Windows Metafile File Type', 'FILE', 'YES', '[qr\'^\\.(wmf)$\' => 0]', '[qr\'^\\.(wmf)$\' => 1]');
INSERT INTO `files` VALUES ('52', 'message/partial', 'rfc2046 URL MIME External-Body Access-Type', 'MIME', 'YES', '[qr\'^message/external-body$\'i => 0]', '[qr\'^message/external-body$\'i => 1]');
INSERT INTO `files` VALUES ('53', 'message/external-body', 'rfc2046 MIME Message/Partial Subtype', 'MIME', 'YES', '[qr\'^message/partial$\'i => 0]', '[qr\'^message/partial$\'i => 1]');
INSERT INTO `files` VALUES ('54', 'Z', '(.Z) Unix-compressed', 'EXT', 'YES', '[qr\'^\\.(Z)$\' => 0]', '[qr\'^\\.(Z)$\' => 1]');
INSERT INTO `files` VALUES ('71', 'mdw', '(.mdw) Microsoft Access Workgroup Information File', 'EXT', 'YES', '[qr\'.\\.(mdw)$\'ix => 0]', '[qr\'.\\.(mdw)$\'ix => 1]');
INSERT INTO `files` VALUES ('72', 'mdt', '(.mdt) Microsoft Access Add-in Data File', 'EXT', 'YES', '[qr\'.\\.(mdt)$\'ix => 0]', '[qr\'.\\.(mdt)$\'ix => 1]');
INSERT INTO `files` VALUES ('67', 'lnk', '(.lnk) Windows File Shortcut', 'EXT', 'YES', '[qr\'.\\.(lnk)$\'ix => 0]', '[qr\'.\\.(lnk)$\'ix => 1]');
INSERT INTO `files` VALUES ('79', 'wsf', '(.wsf) Microsoft Windows Script File', 'EXT', 'YES', '[qr\'.\\.(wsf)$\'ix => 0]', '[qr\'.\\.(wsf)$\'ix => 1]');
INSERT INTO `files` VALUES ('66', 'application/x-zip-compressed', '(application/x-zip-compressed) Zip Compressed File', 'MIME', 'YES', '[qr\'^application/x-zip-compressed$\'i => 0]', '[qr\'^application/x-zip-compressed$\'i => 1]');
INSERT INTO `files` VALUES ('73', 'mdz', '(.mdz) Microsoft Access Wizard Template', 'EXT', 'YES', '[qr\'.\\.(mdz)$\'ix => 0]', '[qr\'.\\.(mdz)$\'ix => 1]');
INSERT INTO `files` VALUES ('74', 'msc', '(.msc) Microsoft Management Console Snap-in Control File', 'EXT', 'YES', '[qr\'.\\.(msc)$\'ix => 0]', '[qr\'.\\.(msc)$\'ix => 1]');
INSERT INTO `files` VALUES ('75', 'msi', '(.msi) Microsoft Windows Installer Package File', 'EXT', 'YES', '[qr\'.\\.(msi)$\'ix => 0]', '[qr\'.\\.(msi)$\'ix => 1]');
INSERT INTO `files` VALUES ('76', 'msp', '(.msp) Microsoft Windows Installer Patch File', 'EXT', 'YES', '[qr\'.\\.(msp)$\'ix => 0]', '[qr\'.\\.(msp)$\'ix => 1]');
INSERT INTO `files` VALUES ('77', 'mst', '(.mst) Microsoft Windows Installer Setup Transform File', 'EXT', 'YES', '[qr\'.\\.(mst)$\'ix => 0]', '[qr\'.\\.(mst)$\'ix => 1]');
INSERT INTO `files` VALUES ('78', 'wsc', '(.wsc) Windows Script Component', 'EXT', 'YES', '[qr\'.\\.(wsc)$\'ix => 0]', '[qr\'.\\.(wsc)$\'ix => 1]');
INSERT INTO `files` VALUES ('69', 'mdb', '(.mdb) Microsoft Access Database File', 'EXT', 'YES', '[qr\'.\\.(mdb)$\'ix => 0]', '[qr\'.\\.(mdb)$\'ix => 1]');
INSERT INTO `files` VALUES ('70', 'mde', '(.mde) Microsoft Access MDE Database File', 'EXT', 'YES', '[qr\'.\\.(mde)$\'ix => 0]', '[qr\'.\\.(mde)$\'ix => 1]');
INSERT INTO `files` VALUES ('80', 'wsh', '(.wsh) Windows Script Host Settings File', 'EXT', 'YES', '[qr\'.\\.(wsh)$\'ix => 0]', '[qr\'.\\.(wsh)$\'ix => 1]');
INSERT INTO `files` VALUES ('81', 'mim', '(.mim) Multi-Purpose Internet Mail Message File', 'EXT', 'YES', '[qr\'.\\.(mim)$\'i => 0]', '[qr\'.\\.(mim)$\'i => 1]');
INSERT INTO `files` VALUES ('82', 'b64', '(.b64) Base 64 MIME-Encoded File', 'EXT', 'YES', '[qr\'.\\.(b64)$\'i => 0]', '[qr\'.\\.(b64)$\'i => 1]');
INSERT INTO `files` VALUES ('83', 'bhx', '(.bhx) BinHex Compressed File ASCII Archive', 'EXT', 'YES', '[qr\'.\\.(bhx)$\'i => 0]', '[qr\'.\\.(bhx)$\'i => 1]');
INSERT INTO `files` VALUES ('84', 'hqx', '(.hqx) Macintosh BinHex 4 Compressed Arhive File', 'EXT', 'YES', '[qr\'.\\.(hqx)$\'i => 0]', '[qr\'.\\.(hqx)$\'i => 1]');
INSERT INTO `files` VALUES ('85', 'xxe', '(.xxe) Xxencoded File', 'EXT', 'YES', '[qr\'.\\.(xxe)$\'i => 0]', '[qr\'.\\.(hqx)$\'i => 1]');
INSERT INTO `files` VALUES ('86', 'uu', '(.uu) Compressed Archive File', 'EXT', 'YES', '[qr\'.\\.(uu)$\'i => 0]', '[qr\'.\\.(uu)$\'i => 1]');
INSERT INTO `files` VALUES ('87', 'uue', '(.uue) Uuencoded File', 'EXT', 'YES', '[qr\'.\\.(uue)$\'i => 0]', '[qr\'.\\.(uue)$\'i => 1]');
INSERT INTO `files` VALUES ('88', 'lha', '(lha) Compressed Archive File', 'FILE', 'YES', '[qr\'^\\.(lha)$\' => 0]', '[qr\'^\\.(lha)$\' => 1]');
INSERT INTO `files` VALUES ('89', 'tnef', '(tnef) Transport Neutral Encapsulated Format File', 'FILE', 'YES', '[qr\'^\\.(tnef)$\' => 0]', '[qr\'^\\.(tnef)$\' => 1]');
INSERT INTO `files` VALUES ('90', 'cab', '(cab) Cabinet File', 'FILE', 'YES', '[qr\'^\\.(cab)$\' => 0]', '[qr\'^\\.(cab)$\' => 1]');
INSERT INTO `files` VALUES ('91', 'dll', '(dll) Windows Dynamic Link Library (File Type)', 'FILE-HIGH', 'YES', '[qr\'^\\.(dll)$\' => 0]', '[qr\'^\\.(dll)$\' => 1]');
INSERT INTO `files` VALUES ('92', 'dll', '(.dll) Windows Dynamic Link Library (Extension)', 'EXT-HIGH', 'YES', '[qr\'.\\.(dll)$\'i => 0]', '[qr\'.\\.(dll)$\'i => 1]');
INSERT INTO `files` VALUES ('93', 'qr\'\\.[^./]*\\.(exe|vbs|pif|scr|bat|cmd|com|cpl|dll|rtf)\\.?', 'Double Extensions in File Name (exe,vbs,pif,scr,bat,cmd,com,cpl,dll,rtf)', 'OTHER', 'YES', '[qr\'\\.[^./]*\\.(exe|vbs|pif|scr|bat|cmd|com|cpl|dll|rtf)\\.?$\'i => 0]', '[qr\'\\.[^./]*\\.(exe|vbs|pif|scr|bat|cmd|com|cpl|dll|rtf)\\.?$\'i => 1]');
INSERT INTO `files` VALUES ('94', 'exe', '(exe) Executable (File Type)', 'FILE', 'YES', '[qr\'^\\.(exe)$\' => 0]', '[qr\'^\\.(exe)$\' => 1]');
INSERT INTO `files` VALUES ('95', 'xls', '(.xls) Microsoft Excel Document', 'EXT', 'NO', '[qr\'.\\.(xls)$\' => 0]\n\n', '[qr\'.\\.(xls)$\' => 1]\n\n');
INSERT INTO `files` VALUES ('96', 'xlsx', '(.xlsx) Microsoft Excel Document (2007 and higher)', 'EXT', 'NO', '[qr\'.\\.(xlsx)$\' => 0]\n\n', '[qr\'.\\.(xlsx)$\' => 1]\n\n');
INSERT INTO `files` VALUES ('97', 'doc', '(.doc) Microsoft Word Document', 'EXT', 'NO', '[qr\'.\\.(doc)$\' => 0]\n\n', '[qr\'.\\.(doc)$\' => 1]\n\n');
INSERT INTO `files` VALUES ('98', 'docx', '(.docx) Microsoft Word Document (2007 and higher)', 'EXT', 'NO', '[qr\'.\\.(docx)$\' => 0]\n\n', '[qr\'.\\.(docx)$\' => 1]\n\n');
INSERT INTO `files` VALUES ('104', '(invoice|scan|rechnung|fattura){1,}.*(doc|xls|docx|xlsx){1,}', 'Any File Named invoice that can be opend by Microsoft Word or Excel', 'CUSTOM-EXPRESSION', 'NO', '[qr\'(invoice|scan|rechnung|fattura){1,}.*(doc|xls|docx|xlsx){1,}\'xi => 0]\n\n', '[qr\'(invoice|scan|rechnung|fattura){1,}.*(doc|xls|docx|xlsx){1,}\'xi => 1]\n\n');
INSERT INTO `files` VALUES ('107', '(tmp){1,}.*(exe){1,}', 'Any Filenames with with a double extension of .tmp.exe', 'CUSTOM-EXPRESSION', 'NO', '[qr\'(tmp){1,}.*(exe){1,}\'xi => 0]\n\n', '[qr\'(tmp){1,}.*(exe){1,}\'xi => 1]\n\n');
INSERT INTO `files` VALUES ('106', '(efax){1,}.*(doc|xls|docx|xlsx){1,}', 'Any File Named efax that can be opened by Microsoft Word or Excel', 'CUSTOM-EXPRESSION', 'NO', '[qr\'(efax){1,}.*(doc|xls|docx|xlsx){1,}\'xi => 0]\n\n', '[qr\'(efax){1,}.*(doc|xls|docx|xlsx){1,}\'xi => 1]\n\n');
INSERT INTO `files` VALUES ('109', 'iso', '(.iso) ISO Image Files', 'EXT', 'NO', '[qr\'.\\.(iso)$\'ix => 0]\n\n', '[qr\'.\\.(iso)$\'ix => 1]\n\n');
INSERT INTO `files` VALUES ('110', 'docm', '(.docm) Microsoft Word Macro Enabled Document (2007 or higher)', 'EXT-HIGH', 'NO', '[qr\'.\\.(docm)$\'ix => 0]\n\n', '[qr\'.\\.(docm)$\'ix => 1]\n\n');
INSERT INTO `files` VALUES ('111', 'dotm', '(.dotm) Microsoft Word Macro Enabled Template (2007 or higher)', 'EXT-HIGH', 'NO', '[qr\'.\\.(dotm)$\'ix => 0]\n\n', '[qr\'.\\.(dotm)$\'ix => 1]\n\n');
INSERT INTO `files` VALUES ('112', 'xlsm', '(.xlsm) Microsoft Excel Macro Enabled Workbook (2007 or higher)', 'EXT-HIGH', 'NO', '[qr\'.\\.(xlsm)$\'ix => 0]\n\n', '[qr\'.\\.(xlsm)$\'ix => 1]\n\n');
INSERT INTO `files` VALUES ('113', 'xltm', '(.xltm) Microsoft Excel Macro Enabled Template (2007 or higher)', 'EXT-HIGH', 'NO', '[qr\'.\\.(xltm)$\'ix => 0]\n\n', '[qr\'.\\.(xltm)$\'ix => 1]\n\n');
INSERT INTO `files` VALUES ('114', '(order){1,}.*(docx|xlsx){1,}', 'Any file named order that can be opened by Microsoft Word or Excel', 'CUSTOM-EXPRESSION', 'NO', '[qr\'(order){1,}.*(docx|xlsx){1,}\'xi => 0]\n\n', '[qr\'(order){1,}.*(docx|xlsx){1,}\'xi => 1]\n\n');

-- ----------------------------
-- Table structure for `firewall`
-- ----------------------------
DROP TABLE IF EXISTS `firewall`;
CREATE TABLE `firewall` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ip` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `datetime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=77 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of firewall
-- ----------------------------

-- ----------------------------
-- Table structure for `header_checks`
-- ----------------------------
DROP TABLE IF EXISTS `header_checks`;
CREATE TABLE `header_checks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `pattern` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of header_checks
-- ----------------------------

-- ----------------------------
-- Table structure for `keywords`
-- ----------------------------
DROP TABLE IF EXISTS `keywords`;
CREATE TABLE `keywords` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keyword` varchar(255) DEFAULT NULL,
  `banned` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of keywords
-- ----------------------------
INSERT INTO `keywords` VALUES ('1', 'select', '1');
INSERT INTO `keywords` VALUES ('2', 'update', '1');
INSERT INTO `keywords` VALUES ('3', 'join', '1');
INSERT INTO `keywords` VALUES ('4', 'delete', '1');
INSERT INTO `keywords` VALUES ('5', 'insert', '1');
INSERT INTO `keywords` VALUES ('7', 'all', '1');
INSERT INTO `keywords` VALUES ('9', 'drop', '1');

-- ----------------------------
-- Table structure for `maddr`
-- ----------------------------
DROP TABLE IF EXISTS `maddr`;
CREATE TABLE `maddr` (
  `partition_tag` int(11) DEFAULT '0',
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `email` varbinary(255) NOT NULL,
  `domain` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `part_email` (`partition_tag`,`email`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of maddr
-- ----------------------------

-- ----------------------------
-- Table structure for `mailaddr`
-- ----------------------------
DROP TABLE IF EXISTS `mailaddr`;
CREATE TABLE `mailaddr` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `priority` int(11) NOT NULL DEFAULT '7',
  `email` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`) USING BTREE
) ENGINE=MyISAM AUTO_INCREMENT=988 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of mailaddr
-- ----------------------------

-- ----------------------------
-- Table structure for `mailaddr_temp`
-- ----------------------------
DROP TABLE IF EXISTS `mailaddr_temp`;
CREATE TABLE `mailaddr_temp` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `recipient_id` int(11) NOT NULL,
  `mailaddr_id` int(11) NOT NULL,
  `receiver` char(255) DEFAULT NULL,
  `sender` varchar(255) DEFAULT NULL,
  `wb` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  `owner` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2241 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of mailaddr_temp
-- ----------------------------

-- ----------------------------
-- Table structure for `malware_databases`
-- ----------------------------
DROP TABLE IF EXISTS `malware_databases`;
CREATE TABLE `malware_databases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `db` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `active` varchar(10) DEFAULT NULL,
  `feed` varchar(50) DEFAULT NULL,
  `fp` varchar(10) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=95 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of malware_databases
-- ----------------------------
INSERT INTO `malware_databases` VALUES ('1', 'junk.ndb', 'SANESECURITY  DATABASE - General high hitting junk, containing spam/phishing/lottery/jobs/419s etc', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('2', 'jurlbl.ndb', 'SANESECURITY DATABASE - Junk Url based', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('3', 'phish.ndb', 'SANESECURITY DATABASE - Phishing', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('4', 'rogue.hdb', 'SANESECURITY DATABASE - Malware, Rogue anti-virus software and Fake codecs etc.  Updated hourly to cover the latest malware threats. Please send any Undetected virus samples to samples@sanesecurity.me.uk', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('5', 'scam.ndb', 'SANESECURITY DATABASE - Spam/scams', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('6', 'spamimg.hdb', 'SANESECURITY DATABASE - Spam images ', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('7', 'spamattach.hdb', 'SANESECURITY DATABASE - Spam Spammed attachments such as pdf/doc/rtf/zip ', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('8', 'blurl.ndb', 'SANESECURITY DATABASE - Blacklisted full urls over the last 7 days, covering malware/spam/phishing. URLs added only when main signatures have failed to detect but are known to be \"bad\"', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('9', 'spear.ndb', 'SANESECURITY DATABASE - Spear phishing email addresses (Autogenerated from https://sourceforge.net/projects/aper/)', 'false', 'sanesecurity', 'medium', '1');
INSERT INTO `malware_databases` VALUES ('10', 'lott.ndb', 'SANESECURITY DATABASE - Lottery ', 'false', 'sanesecurity', 'medium', '1');
INSERT INTO `malware_databases` VALUES ('11', 'spam.ldb', 'SANESECURITY DATABASE - Spam detected using the new Logical Signature type', 'false', 'sanesecurity', 'medium', '1');
INSERT INTO `malware_databases` VALUES ('12', 'spearl.ndb', 'SANESECURITY DATABASE - Spear phishing urls (Autogenerated from https://sourceforge.net/projects/aper/)', 'false', 'sanesecurity', 'medium', '1');
INSERT INTO `malware_databases` VALUES ('13', 'jurlbla.ndb', 'SANESECURITY DATABASE - Junk Url based autogenerated from various feeds', 'false', 'sanesecurity', 'medium', '1');
INSERT INTO `malware_databases` VALUES ('14', 'badmacro.ndb', 'SANESECURITY DATABASE - Blocks dangerous macros embedded in Word/Excel/Xml/RTF/JS documents', 'false', 'sanesecurity', 'medium', '1');
INSERT INTO `malware_databases` VALUES ('15', 'malwarehash.hsb', 'FOXHOLE  DATABASE -Malware hashes without known Size', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('16', 'foxhole_generic.cdb', 'FOXHOLE  DATABASE - This database will block double extensions of certain dangerous filetypes that are contained within Zip, Rar, 7Zip, Arj and Cab files. These files will be detected only if they end in dangerous filestypes such', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('18', 'foxhole_all.cdb', 'FOXHOLE  DATABASE - This database will block all files (single and double extensions) within Zip, Rar and 7z archives that contain dangerous filestypes such as: ade, adp, bat, chm, cmd, com, cpl, exe, hta, ins, isp, jse, lib, md', 'false', 'sanesecurity', 'high', '1');
INSERT INTO `malware_databases` VALUES ('19', 'winnow.attachments.hdb', 'OITC  DATABASE -Spammed attachments such as pdf/doc/rtf/zip as well as malware crypted configs', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('20', 'winnow_malware.hdb', 'OITC  DATABASE -Current virus, trojan and other malware not yet detected by ClamAV', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('21', 'winnow_malware_links.ndb', 'OITC  DATABASE -Links to malware', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('22', 'winnow_extended_malware.hdb', 'OITC  DATABASE -contain hand generated signatures for malware', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('23', 'winnow_bad_cw.hdb', 'OITC  DATABASE -md5 hashes of malware attachments acquired directly from a group of botnets', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('24', 'winnow_phish_complete_url.ndb', 'OITC  DATABASE -Similar to winnow_phish_complete.ndb except that entire urls are used  **DO NOT USE TOGETHER WITH winnow_phish_complete.ndb**', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('25', 'winnow.complex.patterns.ldb', 'OITC  DATABASE - contain hand generated signatures for malware and some egregious fraud ', 'false', 'sanesecurity', 'medium', '1');
INSERT INTO `malware_databases` VALUES ('26', 'winnow_extended_malware_links.ndb', 'OITC  DATABASE - contain hand generated signatures for malware links', 'false', 'sanesecurity', 'medium', '1');
INSERT INTO `malware_databases` VALUES ('27', 'winnow_spam_complete.ndb', 'OITC  DATABASE - Signatures to detect fraud and other malicious spam', 'false', 'sanesecurity', 'medium', '1');
INSERT INTO `malware_databases` VALUES ('28', 'winnow_phish_complete.ndb', 'OITC  DATABASE - Phishing and other malicious urls and compromised hosts **DO NOT USE TOGETHER WITH winnow_phish_complete_url.ndb**', 'false', 'sanesecurity', 'high', '1');
INSERT INTO `malware_databases` VALUES ('29', 'winnow_malware.yara', 'OITC YARA  DATABASE -detect spam ', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('30', 'scamnailer.ndb', 'SCAMNAILER  DATABASE - Spear phishing and other phishing emails', 'false', 'sanesecurity', 'medium', '1');
INSERT INTO `malware_databases` VALUES ('31', 'bofhland_cracked_URL.ndb', 'BOFHLAND DATABASE -Spam URLs ', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('32', 'bofhland_malware_URL.ndb', 'BOFHLAND DATABASE -Malware URLs ', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('33', 'bofhland_phishing_URL.ndb', 'BOFHLAND DATABASE -Phishing URLs', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('34', 'bofhland_malware_attach.hdb', 'BOFHLAND DATABASE -Malware Hashes', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('35', 'hackingteam.hsb', 'ROCKSECURITY DATABASE - Hacking Team hashes', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('36', 'crdfam.clamav.hdb', 'CRDF  DATABASE - List of new threats detected by CRDF Anti Malware ', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('37', 'porcupine.ndb', 'PORCUPINE  DATABASE - Brazilian e-mail phishing and malware signatures ', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('38', 'phishtank.ndb', 'PORCUPINE  DATABASE -Online and valid phishing urls from phishtank.com data feed ', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('39', 'porcupine.hsb', 'PORCUPINE  DATABASE - Sha256 Hashes of VBS and JSE malware, kept for 7 days', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('40', 'Sanesecurity_sigtest.yara', 'SANESECURITY YARA  DATABASE - Sanesecurity test signatures ', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('41', 'Sanesecurity_spam.yara', 'SANESECURITY YARA  DATABASE - detect spam ', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('42', 'sanesecurity.ftm', '*** REQUIRED!! DO NOT DISABLE IF USING SANESECURITY FEED *** Message file types, for best performance', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('43', 'sigwhitelist.ign2', '*** REQUIRED!! DO NOT DISABLE IF USING SANESECURITY FEED *** Fast update file to whitelist any problem signatures', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('44', 'securiteinfo.ign2', '*** REQUIRED!! DO NOT DISABLE IF USING SECURITEINFO FEED ***', 'true', 'securiteinfo', 'low', '1');
INSERT INTO `malware_databases` VALUES ('45', 'securiteinfo.hdb', 'Malwares in the Wild', 'true', 'securiteinfo', 'low', '1');
INSERT INTO `malware_databases` VALUES ('46', 'javascript.ndb', 'Malwares Javascript', 'true', 'securiteinfo', 'low', '1');
INSERT INTO `malware_databases` VALUES ('47', 'securiteinfohtml.hdb', 'Malwares HTML', 'true', 'securiteinfo', 'low', '1');
INSERT INTO `malware_databases` VALUES ('48', 'securiteinfoascii.hdb', 'Text file malwares (Perl or shell scripts, bat files, exploits, ...)\r\nText file malwares (Perl or shell scripts, bat files, exploits, ...)\r\n', 'true', 'securiteinfo', 'low', '1');
INSERT INTO `malware_databases` VALUES ('49', 'securiteinfopdf.hdb', 'Malwares PDF \r\n', 'true', 'securiteinfo', 'low', '1');
INSERT INTO `malware_databases` VALUES ('50', 'spam_marketing.ndb', 'Spam Marketing /  spammer blacklist\r\n', 'false', 'securiteinfo', 'high', '1');
INSERT INTO `malware_databases` VALUES ('51', 'rfxn.ndb', 'HEX Malware detection signatures\r\n', 'true', 'linuxmalwaredetect', 'low', '1');
INSERT INTO `malware_databases` VALUES ('52', 'rfxn.hdb', 'MD5 malware detection signatures', 'true', 'linuxmalwaredetect', 'low', '1');
INSERT INTO `malware_databases` VALUES ('55', 'packer.yar', 'well-known sofware packers\r\n', 'false', 'yararules', 'medium', '1');
INSERT INTO `malware_databases` VALUES ('56', 'crypto.yar', 'detect the existence of cryptographic algoritms\r\n', 'false', 'yararules', 'high', '1');
INSERT INTO `malware_databases` VALUES ('61', 'foxhole_filename.cdb', 'FOXHOLE  DATABASE - This database will block certain commonly known malware filenames within Zip, Rar, 7z, Arj and Cab archives.', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('66', 'malware.expert.hdb', 'MALWARE.EXPERT DATABASE - statics MD5 pattern for files', 'true', 'sanesecurity', 'low', '1');
INSERT INTO `malware_databases` VALUES ('75', 'malware/RANSOM_Petya.yar', 'Detects Petya Ransomware', 'true', 'yararules', 'low', '1');
INSERT INTO `malware_databases` VALUES ('76', 'malware/RANSOM_Petya_MS17_010', 'Probable PETYA ransomware using ETERNALBLUE, WMIC, PsExec', 'true', 'yararules', 'low', '1');
INSERT INTO `malware_databases` VALUES ('94', 'email/EMAIL_Cryptowall.yar', 'email/EMAIL_Cryptowall.yar', 'true', 'yararules', 'low', '1');

-- ----------------------------
-- Table structure for `malware_feeds`
-- ----------------------------
DROP TABLE IF EXISTS `malware_feeds`;
CREATE TABLE `malware_feeds` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `enabled` varchar(10) DEFAULT NULL,
  `update_int` int(11) DEFAULT NULL,
  `code` varchar(255) DEFAULT NULL,
  `product` varchar(255) DEFAULT NULL,
  `list` varchar(255) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  `malwarepatrol_free` varchar(10) DEFAULT NULL,
  `template` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of malware_feeds
-- ----------------------------
INSERT INTO `malware_feeds` VALUES ('1', 'sanesecurity', 'true', null, null, null, null, '2', null, null);
INSERT INTO `malware_feeds` VALUES ('2', 'securiteinfo', 'true', '4', 'e7fe28d465808e0ce4278955d8e0a5bed43f76bae9d6bb24a6f6b9b685696e10b92af719c7adc07aa1ac2cc0dafa6638a0cc0d37688904075c8446781be5bb5f', null, null, '2', null, null);
INSERT INTO `malware_feeds` VALUES ('3', 'linuxmalwaredetect', 'true', '8', null, null, null, '2', null, null);
INSERT INTO `malware_feeds` VALUES ('4', 'yararules', 'true', '1', null, null, null, '2', null, null);
INSERT INTO `malware_feeds` VALUES ('5', 'malwarepatrol', 'true', '2', '106261422496', '15', 'clamav_ext', '2', 'no', null);

-- ----------------------------
-- Table structure for `message_rules`
-- ----------------------------
DROP TABLE IF EXISTS `message_rules`;
CREATE TABLE `message_rules` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rule_name` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `rule_type` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `rule_desc` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `header` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `regex` varchar(255) CHARACTER SET latin1 DEFAULT NULL,
  `score` double DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of message_rules
-- ----------------------------
INSERT INTO `message_rules` VALUES ('11', 'example_body_rule_casesensitive', 'body', 'Example Body Rule Case Sensitive', '', '/\\btest\\b/', '0', '1');
INSERT INTO `message_rules` VALUES ('13', 'example_from_header_rule', 'header', 'Example From Header Rule', 'From', '~ /test\\.com/i', '0', '1');
INSERT INTO `message_rules` VALUES ('14', 'example_uri_rule_order_viagra', 'uri', 'Example URI Rule Match Order Viagra URL in messages', '', '/www\\.example\\.com\\/OrderViagra\\//', '0', '1');
INSERT INTO `message_rules` VALUES ('15', 'example_rawbody_rule', 'rawbody', 'Example Rawbody Rule', '', '/\\<\\-\\-! created with spamware 1\\.0 \\-\\-\\>/', '0', '1');
INSERT INTO `message_rules` VALUES ('16', 'example_subject_header_rule', 'header', 'Example Subject Header Rule', 'Subject', '~ /\\btest\\b/i', '0', '1');

-- ----------------------------
-- Table structure for `msg_cleanup_table`
-- ----------------------------
DROP TABLE IF EXISTS `msg_cleanup_table`;
CREATE TABLE `msg_cleanup_table` (
  `mail_id` varbinary(255) DEFAULT NULL,
  `secret_id` varbinary(255) DEFAULT NULL,
  `time_iso` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of msg_cleanup_table
-- ----------------------------

-- ----------------------------
-- Table structure for `msg_cleanup_table_backup`
-- ----------------------------
DROP TABLE IF EXISTS `msg_cleanup_table_backup`;
CREATE TABLE `msg_cleanup_table_backup` (
  `mail_id` varbinary(255) DEFAULT NULL,
  `secret_id` varbinary(255) DEFAULT NULL,
  `time_iso` timestamp NULL DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of msg_cleanup_table_backup
-- ----------------------------

-- ----------------------------
-- Table structure for `msg_content_type`
-- ----------------------------
DROP TABLE IF EXISTS `msg_content_type`;
CREATE TABLE `msg_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `content_type` char(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `user` int(11) DEFAULT NULL,
  `user_stats` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=13 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of msg_content_type
-- ----------------------------
INSERT INTO `msg_content_type` VALUES ('1', 'V', 'Virus', '1', '1');
INSERT INTO `msg_content_type` VALUES ('2', 'B', 'Banned', '1', '1');
INSERT INTO `msg_content_type` VALUES ('3', 'U', 'Unchecked', '1', null);
INSERT INTO `msg_content_type` VALUES ('4', 'S', 'Spam Quarantined', '1', '1');
INSERT INTO `msg_content_type` VALUES ('6', 'M', 'Bad-Mime', '1', null);
INSERT INTO `msg_content_type` VALUES ('7', 'H', 'Bad-Header', '1', '1');
INSERT INTO `msg_content_type` VALUES ('8', 'O', 'Oversized', '1', null);
INSERT INTO `msg_content_type` VALUES ('9', 'T', 'Mta Error', '1', null);
INSERT INTO `msg_content_type` VALUES ('10', 'C', 'Clean', '1', '1');
INSERT INTO `msg_content_type` VALUES ('11', 's', 'Spam Tagged(OLD)', '1', '1');
INSERT INTO `msg_content_type` VALUES ('12', 'Y', 'Spam Tagged', '1', '1');

-- ----------------------------
-- Table structure for `msgrcpt`
-- ----------------------------
DROP TABLE IF EXISTS `msgrcpt`;
CREATE TABLE `msgrcpt` (
  `partition_tag` int(11) DEFAULT '0',
  `mail_id` varbinary(16) NOT NULL,
  `rseqnum` int(11) NOT NULL DEFAULT '0',
  `rid` bigint(20) unsigned NOT NULL,
  `is_local` char(1) NOT NULL DEFAULT '',
  `content` char(1) NOT NULL DEFAULT '',
  `ds` char(1) NOT NULL,
  `rs` char(1) NOT NULL,
  `bl` char(1) DEFAULT '',
  `wl` char(1) DEFAULT '',
  `bspam_level` float DEFAULT NULL,
  `smtp_resp` varchar(255) DEFAULT '',
  KEY `mail_id` (`mail_id`) USING BTREE,
  KEY `rid` (`rid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of msgrcpt
-- ----------------------------

-- ----------------------------
-- Table structure for `msgs`
-- ----------------------------
DROP TABLE IF EXISTS `msgs`;
CREATE TABLE `msgs` (
  `partition_tag` int(11) NOT NULL DEFAULT '0',
  `mail_id` varbinary(16) NOT NULL,
  `secret_id` varbinary(16) DEFAULT '',
  `am_id` varchar(20) NOT NULL,
  `time_num` int(10) unsigned NOT NULL,
  `time_iso` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `sid` bigint(20) unsigned NOT NULL,
  `policy` varchar(255) DEFAULT '',
  `client_addr` varchar(255) DEFAULT '',
  `size` int(10) unsigned NOT NULL,
  `originating` char(1) NOT NULL DEFAULT '',
  `content` char(1) DEFAULT NULL,
  `quar_type` char(1) DEFAULT NULL,
  `quar_loc` varbinary(255) DEFAULT '',
  `dsn_sent` char(1) DEFAULT NULL,
  `spam_level` float DEFAULT NULL,
  `message_id` varchar(255) DEFAULT '',
  `from_addr` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '',
  `subject` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT '',
  `host` varchar(255) NOT NULL,
  `archive` char(1) DEFAULT 'N',
  PRIMARY KEY (`partition_tag`,`mail_id`),
  KEY `msgs_idx_sid` (`sid`) USING BTREE,
  KEY `msgs_idx_mess_id` (`message_id`) USING BTREE,
  KEY `msgs_idx_time_num` (`time_num`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of msgs
-- ----------------------------

-- ----------------------------
-- Table structure for `parameters`
-- ----------------------------
DROP TABLE IF EXISTS `parameters`;
CREATE TABLE `parameters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parameter` varchar(255) DEFAULT NULL,
  `whitelist` int(11) DEFAULT NULL,
  `blacklist` int(11) DEFAULT NULL,
  `weight` int(11) DEFAULT NULL,
  `smtpd_recipient_restrictions` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `module` varchar(255) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `default_value` varchar(255) DEFAULT NULL,
  `editable` int(11) DEFAULT NULL,
  `conf_file` varchar(255) DEFAULT NULL,
  `description` blob,
  `parent` int(11) DEFAULT NULL,
  `child` int(11) DEFAULT NULL,
  `order1` int(11) DEFAULT NULL,
  `enabled` int(11) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `network_entry` int(11) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=355 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of parameters
-- ----------------------------
INSERT INTO `parameters` VALUES ('1', 'myorigin', null, null, null, null, 'Primary Domain Name', 'postfix', null, 'domain.tld', '1', 'main.cf', 0x5052494D41525920444F4D41494E204E414D45202D20546865207072696D61727920646F6D61696E206E616D6520666F72207468697320736572766572204578616D706C653A20646F6D61696E2E746C64, null, '2', null, '2', '1', null, null, null);
INSERT INTO `parameters` VALUES ('2', 'myhostname', null, null, null, null, 'Host Name', 'postfix', null, 'hermes.domain.tld', '1', 'main.cf', 0x534552564552204E414D45202D20596F757220736572766572206E616D652E204D7573742062652066756C6C79207175616C6966696564206E616D652E204578616D706C653A207365727665722E646F6D61696E2E746C64, null, '2', null, '2', '1', null, null, null);
INSERT INTO `parameters` VALUES ('3', 'mynetworks', null, null, null, null, 'Permitted Networks', 'postfix', null, '127.0.0.1', '1', 'main.cf', 0x414C4C4F574544204E4554574F524B533A204C697374206F6620486F7374732F495020416464726573736573202F4E6574776F726B7320616C6C6F77656420746F2073656E6420656D61696C207468726F7567682074686973207365727665722E204950204578616D706C653A203139322E3136382E302E3130207C20486F7374204578616D706C653A207365727665722E646F6D61696E2E746C64207C204E6574776F726B204578616D706C653A203139322E3136382E302E302F3234, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('4', 'message_size_limit', null, null, null, null, 'System Message Size Limit in MB', 'postfix', null, '10240', '1', 'main.cf', 0x4D4553534147452053495A45204C494D4954202D204D6178696D756D206D6573736167652073697A65206C696D697420696E206D656761627974657320284D4229, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('5', 'smtpd_helo_required', null, null, null, null, 'HELO Required', 'postfix', null, 'yes', '1', 'main.cf', 0x48454C4F205245515549524544202D20526571756972652065787465726E616C20534D5450207365727665727320746F20757365207468652068656C6F20636F6D6D616E64207768656E20636F6E6E656374696E6720746F207468697320736572766572, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('6', 'smtpd_recipient_restrictions', null, null, null, null, 'Recipient Policies', 'postfix', null, 'permit_mynetworks, reject_unauth_destination, reject_unauth_pipelining, reject_rbl_client zombie.dnsbl.sorbs.net, reject_rbl_client sbl.spamhaus.org, reject_rbl_client blackholes.mail-abuse.org, reject_rbl_client bl.spamcop.net, reject_rbl_client cbl.abus', '1', 'main.cf', 0x524543495049454E5420504F4C4943494553202D20506F6C6963696573206170706C696564207768656E2065787465726E616C20534D5450207365727665727320617474656D707420746F2064656C6976657220656D61696C20746F20726563697069656E7473206F6E207468697320736572766572, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('7', 'smtpd_sender_restrictions', null, null, null, null, 'Sender Policies', 'postfix', null, 'check_sender_access mysql:/etc/postfix/mysql-senders.cf, reject_non_fqdn_sender, reject_unknown_sender_domain\r\n', '1', 'main.cf', 0x53454E44455220504F4C4943494553202D20506F6C6963696573206170706C696564207768656E2065787465726E616C2073656E6465727320617474656D707420746F2064656C6976657220652D6D61696C20746F207468697320736572766572, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('8', 'reject_non_fqdn_sender', null, null, null, null, 'Reject Non-FQDN Senders', 'postfix', null, null, '1', 'main.cf', null, '7', '1', '2', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('9', 'reject_unknown_sender_domain', null, null, null, null, 'Reject Unknown Senders', 'postfix', null, null, '1', 'main.cf', null, '7', '1', '3', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('354', 'check_sender_access hash:/etc/postfix/amavis_senderbypass', null, null, null, null, 'Enable Senders List', 'postfix', null, null, '1', 'main.cf', null, '7', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('204', 'smtp_sasl_auth_enable', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('15', '78643200', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '4', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('16', 'yes', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '5', '1', '1', '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('17', 'permit_mynetworks', null, null, null, null, 'Allow Permitted Networks', 'postfix', null, null, '1', 'main.cf', null, '6', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('18', 'reject_unauth_destination', null, null, null, null, 'Reject Unauthorized Destinations', 'postfix', null, null, '1', 'main.cf', null, '6', '1', '2', '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('19', 'check_policy_service unix:private/policy-spf', null, null, null, null, 'Enable SPF', 'postfix', null, null, '1', 'main.cf', null, '6', '1', '999', '2', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('20', 'reject_unauth_pipelining', null, null, null, null, 'Reject Pipelining', 'postfix', null, null, '1', 'main.cf', null, '6', '1', '5', '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('180', 'permit_dnswl_client wl.mailspike.net', null, null, '-2', null, null, 'postfix', null, null, '1', 'main.cf', null, '6', '1', '13', '2', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('242', 'smtp_tls_note_starttls_offer', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('23', 'reject_rbl_client bl.spameatingmonkey.net', null, null, '2', null, 'Enable Mail-abuse Blocklist', 'postfix', null, null, '1', 'main.cf', null, '6', '1', '13', '2', '1', null, null, null);
INSERT INTO `parameters` VALUES ('25', 'deeztek.com', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('26', 'smtp.deeztek.com', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '2', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('29', 'smtpd_client_restrictions', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', 0x434C49454E5420504F4C4943494553202D20506F6C6963696573206170706C696564207768656E2065787465726E616C20534D5450207365727665727320617474656D707420746F20636F6E6E65637420746F207468697320736572766572, null, '2', null, '2', '1', null, null, null);
INSERT INTO `parameters` VALUES ('69', 'reject_unknown_sender_domain', null, null, null, null, 'Reject Unknown Sender Domain', 'postfix', null, null, '1', 'main.cf', null, '6', '1', '7', '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('27', 'ip', null, null, null, null, 'IP Address', 'network', null, '192.168.71.100', '1', 'interfaces', null, null, '2', '2', '2', '1', null, null, null);
INSERT INTO `parameters` VALUES ('28', 'network_mode', null, null, null, null, 'Network Mode', 'network', null, 'static', '1', 'interfaces', null, null, '2', '1', '2', '1', null, null, null);
INSERT INTO `parameters` VALUES ('30', 'smtpd_banner', null, null, null, null, null, 'postfix', null, null, '2', 'main.cf', null, null, '2', null, '2', '1', null, null, null);
INSERT INTO `parameters` VALUES ('66', 'reject_invalid_hostname', null, null, null, null, 'Reject Invalid Hostname', 'postfix', null, null, '1', 'main.cf', null, '6', '1', '4', '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('37', 'check_client_access mysql:/etc/postfix/mysql-rbl_override.cf', null, null, null, null, 'Enable RBL Override List', 'postfix', null, null, '1', 'main.cf', null, '6', '1', '11', '2', '1', null, null, null);
INSERT INTO `parameters` VALUES ('220', 'dnsbl.sorbs.net*2', null, null, '2', null, null, 'postfix', null, null, '1', 'main.cf', null, '79', '1', '18', '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('40', 'check_client_access mysql:/etc/postfix/mysql-clients.cf', null, null, null, null, 'Enable Allowed/Denied Clients List', 'postfix', null, null, '1', 'main.cf', null, '29', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('67', 'check_sender_access mysql:/etc/postfix/mysql-senders.cf', null, null, null, null, 'Enable Sender Access', 'postfix', null, null, '1', 'main.cf', null, '6', '1', '3', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('68', 'reject_non_fqdn_sender', null, null, null, null, 'Reject non FQDN Sender', 'postfix', null, null, '1', 'main.cf', null, '6', '1', '6', '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('70', 'reject_non_fqdn_recipient', null, null, null, null, 'Reject non FQDN Recipient', 'postfix', null, null, '1', 'main.cf', null, '6', '1', '8', '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('71', 'reject_unknown_recipient_domain', null, null, null, null, 'Reject Unknown Recipient Domain', 'postfix', null, null, '1', 'main.cf', null, '6', '1', '9', '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('76', 'permit_dnswl_client list.dnswl.org=127.[0..255].[0..255].0', '1', null, '-2', '2', null, 'postfix', null, null, '1', 'main.cf', null, '6', '1', '12', '2', '1', null, null, null);
INSERT INTO `parameters` VALUES ('77', 'permit_dnswl_client list.dnswl.org=127.[0..255].[0..255].1', '1', null, '-3', '2', null, 'postfix', null, null, '1', 'main.cf', null, '6', '1', '12', '2', '1', null, null, null);
INSERT INTO `parameters` VALUES ('78', 'permit_dnswl_client list.dnswl.org=127.[0..255].[0..255].[2..255]', '1', null, '-4', '2', null, 'postfix', null, null, '1', 'main.cf', null, '6', '1', '12', '2', '1', null, null, null);
INSERT INTO `parameters` VALUES ('79', 'postscreen_dnsbl_sites', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('88', 'bl.spameatingmonkey.net*2', null, null, '2', null, null, 'postfix', null, null, '1', 'main.cf', null, '79', '1', '3', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('94', 'list.dnswl.org=127.[0..255].[0..255].0*-2', null, null, '-2', null, null, 'postfix', null, null, '1', 'main.cf', null, '79', '1', '9', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('95', 'list.dnswl.org=127.[0..255].[0..255].1*-3', null, null, '-3', null, null, 'postfix', null, null, '1', 'main.cf', null, '79', '1', '10', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('96', 'list.dnswl.org=127.[0..255].[0..255].[2..255]*-4', null, null, '-4', null, null, 'postfix', null, null, '1', 'main.cf', null, '79', '1', '11', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('131', 'server_subnet', null, null, null, null, null, 'network', null, null, '1', 'network', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('114', '3', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '113', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('130', '192.168.10.246', null, null, null, null, null, 'network', null, null, '1', 'network', null, '129', '2', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('209', 'psbl.surriel.com', null, null, '1', null, null, 'postfix', null, null, '1', 'main.cf', null, '79', '1', '17', '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('113', 'postscreen_dnsbl_threshold', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('208', 'reject_rbl_client psbl.surriel.com', null, null, '1', null, null, 'postfix', null, null, '1', 'main.cf', null, '6', '1', '13', '2', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('129', 'server_ip', null, null, null, null, null, 'network', null, null, '1', 'network', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('132', '255.255.255.0', null, null, null, null, null, 'network', null, null, '1', 'network', null, '131', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('187', 'postscreen_bare_newline_enable', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('186', 'postscreen_non_smtp_command_enable', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('219', 'reject_rbl_client dnsbl.sorbs.net', null, null, '2', null, null, 'postfix', null, null, '1', 'main.cf', null, '6', '1', '13', '2', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('175', 'bl.spamcop.net*2', null, null, '2', null, null, 'postfix', null, null, '1', 'main.cf', null, '79', '1', '14', '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('181', 'wl.mailspike.net*-2', null, null, '-2', null, null, 'postfix', null, null, '1', 'main.cf', null, '79', '1', '16', '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('174', 'reject_rbl_client bl.spamcop.net', null, null, '2', null, null, 'postfix', null, null, '1', 'main.cf', null, '6', '1', '13', '2', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('230', 'bl.mailspike.net*2', null, null, '2', null, null, 'postfix', null, null, '1', 'main.cf', null, '79', '1', '21', '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('185', 'postscreen_pipelining_enable', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('188', 'no', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '185', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('189', 'no', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '186', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('190', 'no', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '187', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('203', '', null, null, null, null, '', 'postfix', null, null, '1', 'main.cf', null, '202', '1', '1', '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('202', 'relayhost', null, null, null, null, 'Relay Host', 'postfix', null, null, '1', 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('205', 'no', null, null, null, null, null, 'postfix', null, 'yes', '1', 'main.cf', null, '204', '1', '1', '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('206', 'smtp_sasl_password_maps', null, null, null, null, '', 'postfix', null, null, '1', 'main.cf', null, null, '2', null, '1', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('207', 'hash:/etc/postfix/relay_passwd ', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '206', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('210', 'smtpd_tls_security_level', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('211', '', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '210', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('212', 'smtpd_tls_cert_file', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('213', '/opt/hermes/ssl/hermes-tls.cer', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '212', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('214', 'smtpd_tls_key_file', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('215', '/opt/hermes/ssl/hermes-tls.key', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '214', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('216', 'smtpd_tls_CAfile', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('217', '/opt/hermes/ssl/hermes-tls.root.cer', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '216', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('229', 'reject_rbl_client bl.mailspike.net', null, null, '2', null, null, 'postfix', null, null, '1', 'main.cf', null, '6', '1', '13', '2', '1', 'NONE', null, null);
INSERT INTO `parameters` VALUES ('243', 'yes', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '242', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('352', 'inet:127.0.0.1:8891', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '349', '1', '1', '2', '1', null, null, null);
INSERT INTO `parameters` VALUES ('348', 'smtpd_milters', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('349', 'non_smtpd_milters', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('350', 'inet:127.0.0.1:8891', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '348', '1', '1', '2', '1', null, null, null);
INSERT INTO `parameters` VALUES ('321', '30d', null, null, null, null, null, 'postfix', null, null, null, 'main.cf', null, '320', '1', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('318', 'bounce_queue_lifetime', null, null, null, null, null, 'postfix', null, '5d', null, 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('319', '5d', null, null, null, null, null, 'postfix', null, null, null, 'main.cf', null, '318', '1', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('320', 'maximal_queue_lifetime', null, null, null, null, null, 'postfix', null, '5d', null, 'main.cf', null, null, '2', null, '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('351', 'inet:127.0.0.1:54321', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '348', '1', '2', '2', '1', null, null, null);
INSERT INTO `parameters` VALUES ('353', 'inet:127.0.0.1:54321', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '349', '1', '2', '2', '1', null, null, null);

-- ----------------------------
-- Table structure for `parameters_temp`
-- ----------------------------
DROP TABLE IF EXISTS `parameters_temp`;
CREATE TABLE `parameters_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parameter` varchar(255) DEFAULT NULL,
  `whitelist` int(11) DEFAULT NULL,
  `blacklist` int(11) DEFAULT NULL,
  `weight` int(11) DEFAULT NULL,
  `smtpd_recipient_restrictions` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `module` varchar(255) DEFAULT NULL,
  `priority` int(11) DEFAULT NULL,
  `default_value` varchar(255) DEFAULT NULL,
  `editable` int(11) DEFAULT NULL,
  `conf_file` varchar(255) DEFAULT NULL,
  `description` blob,
  `parent` int(11) DEFAULT NULL,
  `child` int(11) DEFAULT NULL,
  `order1` int(11) DEFAULT NULL,
  `enabled` int(11) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=144 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of parameters_temp
-- ----------------------------

-- ----------------------------
-- Table structure for `parameters2`
-- ----------------------------
DROP TABLE IF EXISTS `parameters2`;
CREATE TABLE `parameters2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parameter` varchar(255) DEFAULT NULL,
  `value2` varchar(255) DEFAULT NULL,
  `module` varchar(255) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=88 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of parameters2
-- ----------------------------
INSERT INTO `parameters2` VALUES ('1', 'server_ip_octet1', '192', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('2', 'server_ip_octet2', '168', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('3', 'server_ip_octet3', '69', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('4', 'server_ip_octet4', '254', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('5', 'server_subnet', '255.255.255.0', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('25', 'server_dns1_octet2', '168', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('26', 'server_dns1_octet3', '69', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('9', 'server_network_octet1', null, 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('10', 'server_network_octet2', null, 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('11', 'server_network_octet3', null, 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('12', 'server_network_octet4', null, 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('13', 'server_broadcast_octet1', null, 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('14', 'server_broadcast_octet2', null, 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('15', 'server_broadcast_octet3', null, 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('16', 'server_broadcast_octet4', null, 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('17', 'server_gateway_octet1', '192', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('18', 'server_gateway_octet2', '168', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('19', 'server_gateway_octet3', '69', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('20', 'server_gateway_octet4', '1', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('21', 'server_dns1_octet1', '192', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('22', 'network_mode', 'static', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('23', 'server_name', 'hermes', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('24', 'server_domain', 'domain.tld', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('27', 'server_dns1_octet4', '1', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('28', 'server_dns2_octet1', '', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('29', 'server_dns2_octet2', '', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('30', 'server_dns2_octet3', '', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('31', 'server_dns2_octet4', '', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('32', 'server_dns3_octet1', '', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('33', 'server_dns3_octet2', '', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('34', 'server_dns3_octet3', '', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('35', 'server_dns3_octet4', '', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('36', 'firewall_status', 'disabled', 'firewall', '1', '1');
INSERT INTO `parameters2` VALUES ('55', 'system_log_retention', '30', 'systemlog', '1', '1');
INSERT INTO `parameters2` VALUES ('37', 'ScanMail', 'true', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('38', 'ScanArchive', 'true', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('39', 'ArchiveBlockEncrypted', 'false', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('40', 'ScanPE', 'true', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('41', 'ScanOLE2', 'true', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('42', 'ScanHTML', 'true', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('43', 'AlgorithmicDetection', 'true', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('44', 'ScanELF', 'true', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('45', 'PhishingSignatures', 'true', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('46', 'PhishingScanURLs', 'true', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('47', 'PhishingAlwaysBlockSSLMismatch', 'false', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('48', 'PhishingAlwaysBlockCloak', 'false', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('49', 'DetectPUA', 'false', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('50', 'HeuristicScanPrecedence', 'false', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('51', 'OLE2BlockMacros', 'false', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('52', 'ScanPDF', 'true', 'clamav', '1', '1');
INSERT INTO `parameters2` VALUES ('53', 'system_log_retention', '30', 'systemlog', '1', '1');
INSERT INTO `parameters2` VALUES ('57', 'system_log_retention', '30', 'systemlog', '1', '1');
INSERT INTO `parameters2` VALUES ('59', 'default_action', 'accept', 'dkim', '1', '1');
INSERT INTO `parameters2` VALUES ('60', 'dkim_enable', 'no', 'dkim', '1', '1');
INSERT INTO `parameters2` VALUES ('61', 'body_canonicalization', 'relaxed', 'dkim', '1', '1');
INSERT INTO `parameters2` VALUES ('62', 'badsignature_action', 'accept', 'dkim', '1', '1');
INSERT INTO `parameters2` VALUES ('63', 'dnserror_action', 'tempfail', 'dkim', '1', '1');
INSERT INTO `parameters2` VALUES ('64', 'internalerror_action', 'tempfail', 'dkim', '1', '1');
INSERT INTO `parameters2` VALUES ('65', 'nosignature_action', 'accept', 'dkim', '1', '1');
INSERT INTO `parameters2` VALUES ('66', 'security_action', 'tempfail', 'dkim', '1', '1');
INSERT INTO `parameters2` VALUES ('67', 'signature_algorithm', 'rsa-sha256', 'dkim', '1', '1');
INSERT INTO `parameters2` VALUES ('68', 'headers_canonicalization', 'relaxed', 'dkim', '1', '1');
INSERT INTO `parameters2` VALUES ('69', 'server_ip', '192.168.69.254', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('70', 'server_gateway', '192.168.69.1', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('71', 'server_dns1', '192.168.69.1', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('72', 'server_dns2', '', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('73', 'server_dns3', '', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('74', 'server_broadcast', '', 'network', '1', '1');
INSERT INTO `parameters2` VALUES ('75', 'debugLevel', '1', 'spf', '1', '1');
INSERT INTO `parameters2` VALUES ('76', 'TestOnly', '1', 'spf', '1', '1');
INSERT INTO `parameters2` VALUES ('77', 'HELO_reject', 'Fail', 'spf', '1', '1');
INSERT INTO `parameters2` VALUES ('78', 'Mail_From_reject', 'Fail', 'spf', '1', '1');
INSERT INTO `parameters2` VALUES ('79', 'PermError_reject', 'False', 'spf', '1', '1');
INSERT INTO `parameters2` VALUES ('80', 'TempError_Defer', 'False', 'spf', '1', '1');
INSERT INTO `parameters2` VALUES ('81', 'FailureReports', 'false', 'dmarc', '1', '1');
INSERT INTO `parameters2` VALUES ('82', 'RejectFailures', 'false', 'dmarc', '1', '1');
INSERT INTO `parameters2` VALUES ('83', 'report_email', null, 'dmarc', '1', '1');
INSERT INTO `parameters2` VALUES ('84', 'report_org', null, 'dmarc', '1', '1');
INSERT INTO `parameters2` VALUES ('85', 'interval', 'daily', 'dmarc', '1', '1');
INSERT INTO `parameters2` VALUES ('86', 'startdate', null, 'dmarc', '1', '1');
INSERT INTO `parameters2` VALUES ('87', 'starttime', null, 'dmarc', '1', '1');

-- ----------------------------
-- Table structure for `pgp_keyservers`
-- ----------------------------
DROP TABLE IF EXISTS `pgp_keyservers`;
CREATE TABLE `pgp_keyservers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `keyserver` varchar(255) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of pgp_keyservers
-- ----------------------------
INSERT INTO `pgp_keyservers` VALUES ('7', 'ha.pool.sks-keyservers.net', 'OpenPGP SKS Key Server High Availability');
INSERT INTO `pgp_keyservers` VALUES ('8', 'keyserver.ubuntu.com', 'Ubuntu SKS OpenPGP Public Key Server');

-- ----------------------------
-- Table structure for `policy`
-- ----------------------------
DROP TABLE IF EXISTS `policy`;
CREATE TABLE `policy` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `policy_name` varchar(32) DEFAULT NULL,
  `virus_lover` char(1) DEFAULT NULL,
  `spam_lover` char(1) DEFAULT NULL,
  `banned_files_lover` char(1) DEFAULT NULL,
  `bad_header_lover` char(1) DEFAULT NULL,
  `bypass_virus_checks` char(1) DEFAULT NULL,
  `bypass_spam_checks` char(1) DEFAULT NULL,
  `bypass_banned_checks` char(1) DEFAULT NULL,
  `bypass_header_checks` char(1) DEFAULT NULL,
  `spam_modifies_subj` char(1) DEFAULT NULL,
  `virus_quarantine_to` varchar(64) DEFAULT NULL,
  `spam_quarantine_to` varchar(64) DEFAULT NULL,
  `banned_quarantine_to` varchar(64) DEFAULT NULL,
  `bad_header_quarantine_to` varchar(64) DEFAULT NULL,
  `clean_quarantine_to` varchar(64) DEFAULT NULL,
  `other_quarantine_to` varchar(64) DEFAULT NULL,
  `spam_tag_level` float DEFAULT NULL,
  `spam_tag2_level` float DEFAULT NULL,
  `spam_kill_level` float DEFAULT NULL,
  `spam_dsn_cutoff_level` float DEFAULT NULL,
  `spam_quarantine_cutoff_level` float DEFAULT NULL,
  `addr_extension_virus` varchar(64) DEFAULT NULL,
  `addr_extension_spam` varchar(64) DEFAULT NULL,
  `addr_extension_banned` varchar(64) DEFAULT NULL,
  `addr_extension_bad_header` varchar(64) DEFAULT NULL,
  `warnvirusrecip` char(1) DEFAULT NULL,
  `warnbannedrecip` char(1) DEFAULT NULL,
  `warnbadhrecip` char(1) DEFAULT NULL,
  `newvirus_admin` varchar(64) DEFAULT NULL,
  `virus_admin` varchar(64) DEFAULT NULL,
  `banned_admin` varchar(64) DEFAULT NULL,
  `bad_header_admin` varchar(64) DEFAULT NULL,
  `spam_admin` varchar(64) DEFAULT NULL,
  `message_size_limit` int(11) DEFAULT NULL,
  `banned_rulenames` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=41 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of policy
-- ----------------------------
INSERT INTO `policy` VALUES ('1', 'No Antispam & No Antivirus', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'N', null, null, null, null, null, null, '100', '1000', '10000', null, null, null, null, null, null, 'N', 'N', 'N', null, null, null, null, null, null, 'Default');
INSERT INTO `policy` VALUES ('2', 'Antispam & Antivirus', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'Y', null, null, null, null, null, null, '-50', '4', '10', null, null, null, null, null, null, 'N', 'N', 'N', null, null, null, null, null, null, 'Default');
INSERT INTO `policy` VALUES ('3', 'Antispam Only', 'Y', 'N', 'Y', 'N', 'Y', 'N', 'Y', 'N', 'N', null, null, null, null, null, null, '999', '999', '999', null, null, null, null, null, null, 'N', 'N', 'N', null, null, null, null, null, null, 'Default');
INSERT INTO `policy` VALUES ('4', 'Antivirus Only', 'N', 'Y', 'N', 'Y', 'N', 'Y', 'N', 'Y', 'N', null, null, null, null, null, null, '999', '999', '999', null, null, null, null, null, null, 'N', 'N', 'N', null, null, null, null, null, null, 'Default');
INSERT INTO `policy` VALUES ('7', 'Default', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'Y', null, null, null, null, null, null, '-999', '2', '5', null, null, null, null, null, null, 'N', 'N', 'N', null, null, null, null, null, null, 'Default');

-- ----------------------------
-- Table structure for `policy2`
-- ----------------------------
DROP TABLE IF EXISTS `policy2`;
CREATE TABLE `policy2` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `policy_name` varchar(255) DEFAULT NULL,
  `virus_lover` char(1) DEFAULT 'Y',
  `spam_lover` char(1) DEFAULT 'Y',
  `banned_files_lover` char(1) DEFAULT 'Y',
  `bad_header_lover` char(1) DEFAULT 'Y',
  `bypass_virus_checks` char(1) DEFAULT 'Y',
  `bypass_spam_checks` char(1) DEFAULT 'Y',
  `bypass_banned_checks` char(1) DEFAULT 'Y',
  `bypass_header_checks` char(1) DEFAULT 'Y',
  `discard_viruses` char(1) DEFAULT NULL,
  `discard_spam` char(1) DEFAULT NULL,
  `discard_banned_files` char(1) DEFAULT NULL,
  `discard_bad_headers` char(1) DEFAULT NULL,
  `spam_modifies_subj` char(1) DEFAULT 'N',
  `spam_quarantine_to` varchar(64) DEFAULT NULL,
  `spam_tag_level` float DEFAULT '999',
  `spam_tag2_level` float DEFAULT '999',
  `spam_kill_level` float DEFAULT '999',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of policy2
-- ----------------------------
INSERT INTO `policy2` VALUES ('1', 'No Antispam & No Antivirus', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'Y', 'N', 'N', 'N', 'N', 'N', null, '100', '1000', '10000');
INSERT INTO `policy2` VALUES ('2', 'Antispam & Antivirus', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'Y', 'Y', 'Y', 'Y', 'Y', null, '-50', '4', '10');
INSERT INTO `policy2` VALUES ('3', 'Antispam Only', 'Y', 'N', 'Y', 'N', 'Y', 'N', 'Y', 'N', 'N', 'Y', 'N', 'Y', 'N', null, '999', '999', '999');
INSERT INTO `policy2` VALUES ('4', 'Antivirus Only', 'N', 'Y', 'N', 'Y', 'N', 'Y', 'N', 'Y', 'Y', 'N', 'Y', 'N', 'N', null, '999', '999', '999');
INSERT INTO `policy2` VALUES ('7', 'Default', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'Y', 'Y', 'Y', 'Y', 'Y', null, '-999', '2', '5');
INSERT INTO `policy2` VALUES ('9', 'Dino Edwards', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N', 'Y', 'N', 'Y', 'Y', 'Y', 'tina@getwithme.com', '-999', '1.6', '5');
INSERT INTO `policy2` VALUES ('10', 'Xerox Bad Headers', 'N', 'N', 'N', 'Y', 'N', 'N', 'N', 'Y', 'Y', 'Y', 'Y', 'N', 'Y', null, '-999', '2', '5');

-- ----------------------------
-- Table structure for `postfix_queue`
-- ----------------------------
DROP TABLE IF EXISTS `postfix_queue`;
CREATE TABLE `postfix_queue` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `trans_id` varchar(255) DEFAULT NULL,
  `msg_id` varchar(255) DEFAULT NULL,
  `on_hold` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of postfix_queue
-- ----------------------------

-- ----------------------------
-- Table structure for `postscreen_access`
-- ----------------------------
DROP TABLE IF EXISTS `postscreen_access`;
CREATE TABLE `postscreen_access` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `action2` varchar(255) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=192 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of postscreen_access
-- ----------------------------
INSERT INTO `postscreen_access` VALUES ('53', '23.103.132.0/22', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('54', '23.103.144.0/22', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('55', '23.103.191.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('56', '23.103.198.0/23', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('57', '23.103.200.0/21', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('58', '23.103.136.0/21', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('59', '40.107.0.0/16', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('60', '64.4.22.64/26', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('61', '65.55.83.128/27', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('62', '65.55.88.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('63', '65.55.169.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('64', '94.245.120.64/26', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('65', '104.47.0.0/17', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('66', '134.170.132.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('67', '134.170.140.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('68', '134.170.171.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('69', '157.55.133.160/27', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('70', '157.55.158.0/23', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('71', '157.55.206.0/23', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('72', '157.55.234.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('73', '157.56.73.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('74', '157.56.87.192/26', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('75', '157.56.108.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('76', '157.56.110.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('77', '157.56.111.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('78', '157.56.112.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('79', '157.56.206.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('80', '157.56.208.0/22', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('81', '207.46.51.64/26', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('82', '207.46.100.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('83', '207.46.101.128/26', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('84', '207.46.163.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('85', '213.199.154.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('86', '213.199.180.128/26', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('87', '216.32.180.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('88', '216.32.181.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('93', '65.54.190.0/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('94', '65.54.190.64/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('95', '65.54.190.128/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('96', '65.54.190.192/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('97', '65.55.116.0/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('98', '65.55.111.64/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('99', '65.55.116.64/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('100', '65.55.111.128/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('101', '65.55.34.0/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('102', '65.55.34.64/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('103', '65.55.34.128/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('104', '65.55.34.192/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('105', '65.55.90.0/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('106', '65.55.90.64/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('107', '65.55.90.128/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('108', '65.55.90.192/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('109', '65.54.51.64/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('110', '65.54.61.64/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('111', '207.46.66.0/28', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('112', '157.55.0.192/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('113', '157.55.1.128/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('114', '157.55.2.0/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('115', '157.55.2.64/26', 'permit', 'NONE', '1', 'Outlook.com Outbound IP Space');
INSERT INTO `postscreen_access` VALUES ('116', '23.103.144.0/20', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('117', '23.103.156.0/22', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('118', '23.103.198.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('119', '23.103.199.0/24', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('120', '23.103.200.0/22', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('121', '23.103.212.0/22', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('122', '40.92.0.0/14', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('123', '40.107.0.0/17', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('124', '40.107.128.0/18', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('125', '52.100.0.0/14', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('126', '104.212.58.0/23', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('127', '157.56.110.0/23', 'permit', 'NONE', '1', 'Exchange Online Protection');
INSERT INTO `postscreen_access` VALUES ('128', '213.32.180.0/23', 'permit', 'NONE', '1', 'Exchange Online Protection');

-- ----------------------------
-- Table structure for `rbl_override`
-- ----------------------------
DROP TABLE IF EXISTS `rbl_override`;
CREATE TABLE `rbl_override` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=27 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of rbl_override
-- ----------------------------
INSERT INTO `rbl_override` VALUES ('22', '209.17.115.61', 'OK');

-- ----------------------------
-- Table structure for `recipient_certificates`
-- ----------------------------
DROP TABLE IF EXISTS `recipient_certificates`;
CREATE TABLE `recipient_certificates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `smime_certificate_key` varchar(255) DEFAULT NULL,
  `external_ca` int(11) DEFAULT NULL,
  `smime_certificate_request` varchar(255) DEFAULT NULL,
  `smime_certificate_name` varchar(255) DEFAULT NULL,
  `pfx_certificate_name` varchar(255) DEFAULT NULL,
  `smime_certificate_password` varchar(255) DEFAULT NULL,
  `smime_certificate_expiration` date DEFAULT NULL,
  `validity` varchar(255) DEFAULT NULL,
  `encryption` varchar(255) DEFAULT NULL,
  `algorithm` varchar(255) DEFAULT NULL,
  `ca_id` int(11) DEFAULT NULL,
  `serial` varchar(255) DEFAULT NULL,
  `external_ca_name` varchar(255) DEFAULT NULL,
  `thumbprint` varchar(255) DEFAULT NULL,
  `djigzo_certificate_id` int(11) DEFAULT NULL,
  `external` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=188 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of recipient_certificates
-- ----------------------------

-- ----------------------------
-- Table structure for `recipient_keystores`
-- ----------------------------
DROP TABLE IF EXISTS `recipient_keystores`;
CREATE TABLE `recipient_keystores` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `user_name` varchar(255) DEFAULT NULL,
  `pgp_keystore_password` varchar(255) DEFAULT NULL,
  `pgp_keystore_expiration` datetime DEFAULT NULL,
  `pgp_keystore_creation` datetime DEFAULT NULL,
  `encryption` varchar(255) DEFAULT NULL,
  `algorithm` varchar(255) DEFAULT NULL,
  `pgp_fingerprint` varchar(255) DEFAULT NULL,
  `pgp_fingerprint_sha256` varchar(255) DEFAULT NULL,
  `pgp_key_id` varchar(255) DEFAULT NULL,
  `djigzo_keystore_id` int(11) DEFAULT NULL,
  `external` int(11) DEFAULT NULL,
  `master` int(11) DEFAULT NULL,
  `parent` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=402 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of recipient_keystores
-- ----------------------------

-- ----------------------------
-- Table structure for `recipients`
-- ----------------------------
DROP TABLE IF EXISTS `recipients`;
CREATE TABLE `recipients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `policy_id` int(11) DEFAULT NULL,
  `recipient` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `pdf_enabled` int(11) DEFAULT NULL,
  `smime_enabled` int(11) DEFAULT NULL,
  `pgp_enabled` int(11) DEFAULT NULL,
  `smime_mode` int(11) DEFAULT NULL,
  `external_ca` int(11) DEFAULT NULL,
  `smime_certificate_key` varchar(255) DEFAULT NULL,
  `smime_certificate_request` varchar(255) DEFAULT NULL,
  `smime_certificate_name` varchar(255) DEFAULT NULL,
  `digital_sign` int(11) DEFAULT NULL,
  `pfx_certificate_name` varchar(255) DEFAULT NULL,
  `smime_certificate_password` varchar(255) DEFAULT NULL,
  `smime_certificate_expiration` date DEFAULT NULL,
  `validity` varchar(255) DEFAULT NULL,
  `encryption` varchar(255) DEFAULT NULL,
  `algorithm` varchar(255) DEFAULT NULL,
  `ca_id` int(11) DEFAULT NULL,
  `configured` int(11) DEFAULT NULL,
  `domain` int(11) DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT '7',
  `uniqueid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1481 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of recipients
-- ----------------------------
INSERT INTO `recipients` VALUES ('1480', null, '@domain.tld', null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, '1', '7', null);

-- ----------------------------
-- Table structure for `recipients_temp`
-- ----------------------------
DROP TABLE IF EXISTS `recipients_temp`;
CREATE TABLE `recipients_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `policy_id` int(11) DEFAULT NULL,
  `recipient` varchar(255) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `delete_id` int(11) DEFAULT NULL,
  `pdf_enabled` int(11) DEFAULT NULL,
  `smime_enabled` int(11) DEFAULT NULL,
  `pgp_enabled` int(11) DEFAULT NULL,
  `digital_sign` int(11) DEFAULT NULL,
  `validity` varchar(255) DEFAULT NULL,
  `encryption` varchar(255) DEFAULT NULL,
  `algorithm` varchar(255) DEFAULT NULL,
  `smime_password` varchar(255) DEFAULT NULL,
  `smime_certificate_key` varchar(255) DEFAULT NULL,
  `pfx_certificate_name` varchar(255) DEFAULT NULL,
  `smime_certificate_request` varchar(255) DEFAULT NULL,
  `smime_certificate_name` varchar(255) DEFAULT NULL,
  `ca_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=11227 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of recipients_temp
-- ----------------------------

-- ----------------------------
-- Table structure for `restore_jobs`
-- ----------------------------
DROP TABLE IF EXISTS `restore_jobs`;
CREATE TABLE `restore_jobs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(255) DEFAULT NULL,
  `server` varchar(255) DEFAULT NULL,
  `domain` varchar(255) DEFAULT NULL,
  `share` varchar(255) DEFAULT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `mysqlusername` varchar(255) DEFAULT NULL,
  `mysqlpassword` varchar(255) DEFAULT NULL,
  `scheduled` int(11) DEFAULT NULL,
  `scheduled_interval` varchar(255) DEFAULT NULL,
  `directory` varchar(255) DEFAULT NULL,
  `startdate` timestamp NULL DEFAULT NULL,
  `notification` varchar(255) DEFAULT NULL,
  `retention` int(11) DEFAULT NULL,
  `status` varchar(255) NOT NULL DEFAULT '',
  `archive` varchar(255) DEFAULT NULL,
  `encrypt` varchar(255) DEFAULT NULL,
  `restoreprevious` varchar(255) DEFAULT NULL,
  `smbversion` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`,`status`)
) ENGINE=MyISAM AUTO_INCREMENT=78 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of restore_jobs
-- ----------------------------
INSERT INTO `restore_jobs` VALUES ('72', null, null, null, null, null, null, null, null, null, null, null, null, null, null, '', null, null, null, null);

-- ----------------------------
-- Table structure for `salt`
-- ----------------------------
DROP TABLE IF EXISTS `salt`;
CREATE TABLE `salt` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `salt` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=14825 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of salt
-- ----------------------------
INSERT INTO `salt` VALUES ('13638', '2nDe8fJr');
INSERT INTO `salt` VALUES ('13639', '9QgJewsb');
INSERT INTO `salt` VALUES ('13640', 'gv3lE7hS');
INSERT INTO `salt` VALUES ('13641', 'NwCMTzLY');
INSERT INTO `salt` VALUES ('13825', '4!GsjCPzqV');

-- ----------------------------
-- Table structure for `searches`
-- ----------------------------
DROP TABLE IF EXISTS `searches`;
CREATE TABLE `searches` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customtrans` varchar(255) DEFAULT NULL,
  `started` timestamp NULL DEFAULT NULL,
  `ended` timestamp NULL DEFAULT NULL,
  `searchfor` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of searches
-- ----------------------------

-- ----------------------------
-- Table structure for `senders`
-- ----------------------------
DROP TABLE IF EXISTS `senders`;
CREATE TABLE `senders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sender` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=413 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of senders
-- ----------------------------
INSERT INTO `senders` VALUES ('412', 'domain.tld', 'OK');

-- ----------------------------
-- Table structure for `spam_policies`
-- ----------------------------
DROP TABLE IF EXISTS `spam_policies`;
CREATE TABLE `spam_policies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `policy_id` int(11) DEFAULT NULL,
  `policy_name` varchar(255) DEFAULT NULL,
  `custom` int(11) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  `default_policy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=45 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of spam_policies
-- ----------------------------
INSERT INTO `spam_policies` VALUES ('1', '1', 'No Antispam & No Antivirus', '2', '1', '2');
INSERT INTO `spam_policies` VALUES ('2', '2', 'Antispam & Antivirus', '2', '1', '2');
INSERT INTO `spam_policies` VALUES ('3', '3', 'Antispam Only', '2', '1', '2');
INSERT INTO `spam_policies` VALUES ('4', '4', 'Antivirus Only', '2', '1', '2');
INSERT INTO `spam_policies` VALUES ('5', '7', 'Default', '2', '1', '1');

-- ----------------------------
-- Table structure for `spam_settings`
-- ----------------------------
DROP TABLE IF EXISTS `spam_settings`;
CREATE TABLE `spam_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parameter` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `default_local` varchar(255) DEFAULT NULL,
  `default_network` varchar(255) DEFAULT NULL,
  `default_bayes` varchar(255) DEFAULT NULL,
  `default_bayes_network` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `spamfilter` int(11) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1474 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of spam_settings
-- ----------------------------
INSERT INTO `spam_settings` VALUES ('1', 'user_portal', 'https://hermes.domain.tld:9080/users', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('2', 'sa_spam_modifies_subj', '1', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('3', 'sa_spam_subject_tag', '[SUSPECTED SPAM]', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('4', 'final_virus_destiny', 'D_BOUNCE', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('5', 'final_banned_destiny', 'D_BOUNCE', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('6', 'final_spam_destiny', 'D_DISCARD', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('7', 'final_bad_header_destiny', 'D_DISCARD', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('9', 'use_dcc', '1', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('10', 'use_pyzor', '1', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('11', 'use_razor2', '1', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('12', 'use_bayes', '1', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('13', 'bayes_auto_learn', '0', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('1472', 'DKIM_ADSP_DISCARD', '10', null, null, null, null, 'DKIM: Domain signs all mail and suggests discarding mail with no valid author domain signature, no valid author domain signature', '1', '1', '1');
INSERT INTO `spam_settings` VALUES ('1467', 'SPF_FAIL', '4', null, null, null, null, 'SPF: sender does not match SPF record (fail)', '1', '1', '1');
INSERT INTO `spam_settings` VALUES ('1468', 'SPF_HELO_FAIL', '4', null, null, null, null, 'SPF: HELO does not match SPF record (fail)', '1', '1', '1');
INSERT INTO `spam_settings` VALUES ('1469', 'SPF_HELO_SOFTFAIL', '3', null, null, null, null, 'SPF: HELO does not match SPF record (softfail)', '1', '1', '1');
INSERT INTO `spam_settings` VALUES ('1470', 'SPF_SOFTFAIL', '3', null, null, null, null, 'SPF: sender does not match SPF record (softfail)', '1', '1', '1');
INSERT INTO `spam_settings` VALUES ('1471', 'DKIM_ADSP_ALL', '3', null, null, null, null, 'DKIM: No valid author signature, domain signs all mail', '1', '1', '1');
INSERT INTO `spam_settings` VALUES ('1462', 'bayes_auto_learn_threshold_nonspam', '-5', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('1463', 'bayes_auto_learn_threshold_spam', '15', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('1444', 'previous_use_bayes', '1', null, null, null, null, null, null, null, null);
INSERT INTO `spam_settings` VALUES ('1473', 'DKIM_ADSP_NXDOMAIN', '3', null, null, null, null, 'DKIM: No valid author signature and domain not in DNS', '1', '1', '1');

-- ----------------------------
-- Table structure for `spf_bypass`
-- ----------------------------
DROP TABLE IF EXISTS `spf_bypass`;
CREATE TABLE `spf_bypass` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `entry_note` varchar(255) DEFAULT NULL,
  `entry_type` varchar(255) DEFAULT NULL,
  `entry` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of spf_bypass
-- ----------------------------

-- ----------------------------
-- Table structure for `subnet`
-- ----------------------------
DROP TABLE IF EXISTS `subnet`;
CREATE TABLE `subnet` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value2` varchar(255) DEFAULT NULL,
  `value3` varchar(255) DEFAULT NULL,
  `mask` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=34 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of subnet
-- ----------------------------
INSERT INTO `subnet` VALUES ('2', '255.255.255.248', '29', '/29 (255.255.255.248)');
INSERT INTO `subnet` VALUES ('3', '255.255.255.240', '28', '/28 (255.255.255.240)');
INSERT INTO `subnet` VALUES ('4', '255.255.255.224', '27', '/27 (255.255.255.224)');
INSERT INTO `subnet` VALUES ('5', '255.255.255.192', '26', '/26 (255.255.255.192)');
INSERT INTO `subnet` VALUES ('6', '255.255.255.128', '25', '/25 (255.255.255.128)');
INSERT INTO `subnet` VALUES ('7', '255.255.255.0', '24', '/24 (255.255.255.0)');
INSERT INTO `subnet` VALUES ('8', '255.255.254.0', '23', '/23 (255.255.254.0)');
INSERT INTO `subnet` VALUES ('9', '255.255.252.0', '22', '/22 (255.255.252.0)');
INSERT INTO `subnet` VALUES ('10', '255.255.248.0', '21', '/21 (255.255.248.0)');
INSERT INTO `subnet` VALUES ('11', '255.255.240.0', '20', '/20 (255.255.240.0)');
INSERT INTO `subnet` VALUES ('12', '255.255.224.0', '19', '/19 (255.255.224.0)');
INSERT INTO `subnet` VALUES ('13', '255.255.192.0', '18', '/18 (255.255.192.0)');
INSERT INTO `subnet` VALUES ('14', '255.255.128.0', '17', '/17 (255.255.128.0)');
INSERT INTO `subnet` VALUES ('15', '255.255.0.0', '16', '/16 (255.255.0.0)');
INSERT INTO `subnet` VALUES ('16', '255.254.0.0', '15', '/15 (255.254.0.0)');
INSERT INTO `subnet` VALUES ('17', '255.252.0.0', '14', '/14 (255.252.0.0)');
INSERT INTO `subnet` VALUES ('18', '255.248.0.0', '13', '/13 (255.248.0.0)');
INSERT INTO `subnet` VALUES ('19', '255.240.0.0', '12', '/12 (255.240.0.0)');
INSERT INTO `subnet` VALUES ('20', '255.224.0.0', '11', '/11 (255.224.0.0)');
INSERT INTO `subnet` VALUES ('21', '255.192.0.0', '10', '/10 (255.192.0.0)');
INSERT INTO `subnet` VALUES ('22', '255.128.0.0', '9', '/9 (255.128.0.0)');
INSERT INTO `subnet` VALUES ('23', '255.0.0.0', '8', '/8 (255.0.0.0)');
INSERT INTO `subnet` VALUES ('31', '255.255.255.252', '30', '/30 (255.255.255.252)');
INSERT INTO `subnet` VALUES ('32', '255.255.255.254', '31', '/31 (255.255.255.254)');

-- ----------------------------
-- Table structure for `system_settings`
-- ----------------------------
DROP TABLE IF EXISTS `system_settings`;
CREATE TABLE `system_settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `parameter` varchar(255) NOT NULL DEFAULT '',
  `value` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`,`parameter`),
  UNIQUE KEY `parameter` (`parameter`)
) ENGINE=MyISAM AUTO_INCREMENT=75 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of system_settings
-- ----------------------------
INSERT INTO `system_settings` VALUES ('1', 'default_domain', null);
INSERT INTO `system_settings` VALUES ('2', 'postmaster', 'postmaster@domain.tld');
INSERT INTO `system_settings` VALUES ('3', 'pdf_sender', null);
INSERT INTO `system_settings` VALUES ('4', 'portal_url', null);
INSERT INTO `system_settings` VALUES ('25', 'certificate_file', null);
INSERT INTO `system_settings` VALUES ('7', 'version_no', '18.04');
INSERT INTO `system_settings` VALUES ('8', 'admin_email', 'someone@otherdomain.tld');
INSERT INTO `system_settings` VALUES ('9', 'company', '');
INSERT INTO `system_settings` VALUES ('10', 'address', '');
INSERT INTO `system_settings` VALUES ('11', 'address2', null);
INSERT INTO `system_settings` VALUES ('12', 'address3', null);
INSERT INTO `system_settings` VALUES ('13', 'city', '');
INSERT INTO `system_settings` VALUES ('14', 'state', '');
INSERT INTO `system_settings` VALUES ('15', 'zip', '');
INSERT INTO `system_settings` VALUES ('16', 'users', '9999');
INSERT INTO `system_settings` VALUES ('24', 'certificate_mode', 'self');
INSERT INTO `system_settings` VALUES ('17', 'country', null);
INSERT INTO `system_settings` VALUES ('23', 'accepted', '1');
INSERT INTO `system_settings` VALUES ('22', 'random', null);
INSERT INTO `system_settings` VALUES ('21', 'serial', '');
INSERT INTO `system_settings` VALUES ('19', 'wizard_domain', '2');
INSERT INTO `system_settings` VALUES ('20', 'wizard_settings', '2');
INSERT INTO `system_settings` VALUES ('26', 'authkey', '2');
INSERT INTO `system_settings` VALUES ('65', 'mysql_username_hermes', '');
INSERT INTO `system_settings` VALUES ('66', 'mysql_password_hermes', '');
INSERT INTO `system_settings` VALUES ('67', 'mysql_username_djigzo', '');
INSERT INTO `system_settings` VALUES ('68', 'mysql_password_djigzo', '');
INSERT INTO `system_settings` VALUES ('69', 'mysql_username_syslog', '');
INSERT INTO `system_settings` VALUES ('70', 'mysql_password_syslog', '');
INSERT INTO `system_settings` VALUES ('71', 'archive_interval', '180');
INSERT INTO `system_settings` VALUES ('72', 'build_no', '200125');
INSERT INTO `system_settings` VALUES ('73', 'mysql_username_opendmarc', '');
INSERT INTO `system_settings` VALUES ('74', 'mysql_password_opendmarc', '');

-- ----------------------------
-- Table structure for `system_updates`
-- ----------------------------
DROP TABLE IF EXISTS `system_updates`;
CREATE TABLE `system_updates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `version` varchar(255) DEFAULT NULL,
  `build` varchar(255) DEFAULT NULL,
  `status` int(11) DEFAULT NULL,
  `date_installed` timestamp NULL DEFAULT NULL,
  `install_order` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of system_updates
-- ----------------------------
INSERT INTO `system_updates` VALUES ('29', '16.04', '180831', '1', '2018-08-31 00:00:00', '1');
INSERT INTO `system_updates` VALUES ('34', '16.04', '181221', '1', '2018-12-21 11:49:04', '2');
INSERT INTO `system_updates` VALUES ('35', '16.04', '190405', '1', '2019-04-07 05:33:23', '3');
INSERT INTO `system_updates` VALUES ('36', '16.04', '190415', '1', '2019-05-07 10:03:39', '4');
INSERT INTO `system_updates` VALUES ('37', '18.04', '191205', '1', '2019-12-05 00:00:00', '5');
INSERT INTO `system_updates` VALUES ('38', '18.04', '200125', '1', '2020-01-25 00:00:00', '6');

-- ----------------------------
-- Table structure for `system_users`
-- ----------------------------
DROP TABLE IF EXISTS `system_users`;
CREATE TABLE `system_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of system_users
-- ----------------------------
INSERT INTO `system_users` VALUES ('1', 'admin', 'AJVm@ECdx7*nByXuWr$jM5siHQLqe$9A2F7CBDF2575E1A2209671B495CC394BE226E095CEDFE8B959330D3C900A69F6506492372E274B7AC4F4B31538A1378540616CB22BEABB0042E39DDE7AE1E19', '1');

-- ----------------------------
-- Table structure for `tasks`
-- ----------------------------
DROP TABLE IF EXISTS `tasks`;
CREATE TABLE `tasks` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `priority` int(11) DEFAULT NULL,
  `transaction` varchar(255) DEFAULT NULL,
  `date_time_submitted` timestamp NULL DEFAULT NULL,
  `session_no` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  `property` varchar(255) DEFAULT NULL,
  `value` varchar(255) DEFAULT NULL,
  `user_domain` varchar(255) DEFAULT NULL,
  `completed` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=2874 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of tasks
-- ----------------------------
INSERT INTO `tasks` VALUES ('2484', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1577', '1', 'edit', '2013-04-23 15:38:59', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'false', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1578', null, 'edit', '2013-04-23 15:39:30', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1579', null, 'edit', '2013-04-23 15:39:30', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1580', '1', 'importcert', '2013-04-23 15:39:57', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '-import -pfx', 'ALREADY_SET', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/kaitlynmydirectmailnet.pfx', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1581', '1', 'delete', null, 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--delete-user', null, 'dedwards@sra.state.md.us', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1582', '1', 'add', '2013-04-25 13:03:23', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--add-user', null, 'dedwards@sra.state.md.us', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1583', null, 'edit', '2013-04-25 13:03:23', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.locality', 'external', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1584', null, 'edit', '2013-04-25 13:03:23', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1585', null, 'edit', '2013-04-25 13:03:23', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1586', '1', 'importcert', '2013-04-25 13:03:23', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '-import -pfx', 'ALREADY_SET', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/dedwardssrastatemdus.pfx', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1587', null, 'edit', '2013-04-25 13:03:23', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.encryptMode', 'mandatory', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1588', '1', 'delete', null, 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--delete-user', null, 'dedwards@sra.state.md.us', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1589', '1', 'add', '2013-04-25 14:41:45', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--add-user', null, 'bob@aol.com', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1590', null, 'edit', '2013-04-25 14:41:45', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.locality', 'external', 'bob@aol.com', '1');
INSERT INTO `tasks` VALUES ('1591', null, 'edit', '2013-04-25 14:41:45', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.encryptMode', 'mandatory', 'bob@aol.com', '1');
INSERT INTO `tasks` VALUES ('1592', null, 'edit', '2013-04-25 14:41:45', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'false', 'bob@aol.com', '1');
INSERT INTO `tasks` VALUES ('1593', null, 'edit', '2013-04-25 14:41:45', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'bob@aol.com', '1');
INSERT INTO `tasks` VALUES ('1594', null, 'edit', '2013-04-25 14:41:45', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.passwordsSendToOriginator', 'false', 'bob@aol.com', '1');
INSERT INTO `tasks` VALUES ('1595', null, 'edit', '2013-04-25 14:41:45', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.otpEnabled', 'true', 'bob@aol.com', '1');
INSERT INTO `tasks` VALUES ('1596', '1', 'add', '2013-04-25 14:42:18', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--add-user', null, 'jane@aol.com', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1597', null, 'edit', '2013-04-25 14:42:18', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.locality', 'external', 'jane@aol.com', '1');
INSERT INTO `tasks` VALUES ('1598', null, 'edit', '2013-04-25 14:42:18', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.encryptMode', 'mandatory', 'jane@aol.com', '1');
INSERT INTO `tasks` VALUES ('1599', null, 'edit', '2013-04-25 14:42:18', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'false', 'jane@aol.com', '1');
INSERT INTO `tasks` VALUES ('1600', null, 'edit', '2013-04-25 14:42:18', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'jane@aol.com', '1');
INSERT INTO `tasks` VALUES ('1601', null, 'edit', '2013-04-25 14:42:18', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.passwordsSendToOriginator', 'false', 'jane@aol.com', '1');
INSERT INTO `tasks` VALUES ('1602', null, 'edit', '2013-04-25 14:42:18', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.otpEnabled', 'true', 'jane@aol.com', '1');
INSERT INTO `tasks` VALUES ('1603', '1', 'delete', null, 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--delete-user', null, 'bob@aol.com', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1604', '1', 'delete', null, 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--delete-user', null, 'jane@aol.com', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1605', '1', 'add', '2013-04-25 15:00:51', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--add-user', null, 'bob@aol.com', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1606', null, 'edit', '2013-04-25 15:00:51', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.locality', 'external', 'bob@aol.com', '1');
INSERT INTO `tasks` VALUES ('1607', null, 'edit', '2013-04-25 15:00:51', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.encryptMode', 'mandatory', 'bob@aol.com', '1');
INSERT INTO `tasks` VALUES ('1608', null, 'edit', '2013-04-25 15:00:51', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'false', 'bob@aol.com', '1');
INSERT INTO `tasks` VALUES ('1609', null, 'edit', '2013-04-25 15:00:51', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'bob@aol.com', '1');
INSERT INTO `tasks` VALUES ('1610', null, 'edit', '2013-04-25 15:00:51', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.passwordsSendToOriginator', 'false', 'bob@aol.com', '1');
INSERT INTO `tasks` VALUES ('1611', null, 'edit', '2013-04-25 15:00:51', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.otpEnabled', 'true', 'bob@aol.com', '1');
INSERT INTO `tasks` VALUES ('1612', '1', 'delete', null, 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--delete-user', null, 'bob@aol.com', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1613', '1', 'add', '2013-04-26 08:50:11', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--add-user', null, 'dedwards@sra.state.md.us', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1614', null, 'edit', '2013-04-26 08:50:11', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.locality', 'external', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1615', null, 'edit', '2013-04-26 08:50:11', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.encryptMode', 'allow', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1616', null, 'edit', '2013-04-26 08:50:11', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'false', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1617', null, 'edit', '2013-04-26 08:50:11', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1618', null, 'edit', '2013-04-26 08:50:11', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.otpEnabled', 'true', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1619', null, 'edit', '2013-04-26 08:50:11', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.autoCreateClientSecret', 'true', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1620', null, 'edit', '2013-04-26 08:50:11', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.passwordLength', '16', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1621', '1', 'delete', null, 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--delete-user', null, 'dedwards@sra.state.md.us', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1622', '1', 'add', '2013-05-01 10:46:03', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--add-user', null, 'dedwards@sra.state.md.us', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1623', null, 'edit', '2013-05-01 10:46:03', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.locality', 'external', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1624', null, 'edit', '2013-05-01 10:46:03', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.encryptMode', 'mandatory', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1625', null, 'edit', '2013-05-01 10:46:03', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'false', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1626', null, 'edit', '2013-05-01 10:46:03', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1627', null, 'edit', '2013-05-01 10:46:03', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.passwordsSendToOriginator', 'true', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1628', null, 'edit', '2013-05-01 10:46:03', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.passwordValidityInterval', '14400000', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1629', null, 'edit', '2013-05-01 10:46:03', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.passwordLength', '16', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1630', '1', 'delete', null, 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--delete-user', null, 'dedwards@sra.state.md.us', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1631', '1', 'add', '2013-05-01 10:54:16', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--add-user', null, 'dedwards@sra.state.md.us', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1632', null, 'edit', '2013-05-01 10:54:16', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.locality', 'external', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1633', null, 'edit', '2013-05-01 10:54:16', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.encryptMode', 'allow', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1634', null, 'edit', '2013-05-01 10:54:16', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'false', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1635', null, 'edit', '2013-05-01 10:54:16', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1636', null, 'edit', '2013-05-01 10:54:16', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.passwordsSendToOriginator', 'true', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1637', null, 'edit', '2013-05-01 10:54:16', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.passwordValidityInterval', '3600000', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1638', null, 'edit', '2013-05-01 10:54:16', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.passwordLength', '16', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1639', '1', 'delete', null, 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--delete-user', null, 'dedwards@sra.state.md.us', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1640', '1', 'add', '2013-05-01 11:02:19', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--add-user', null, 'dedwards@sra.state.md.us', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1641', null, 'edit', '2013-05-01 11:02:19', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.locality', 'external', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1642', null, 'edit', '2013-05-01 11:02:19', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.encryptMode', 'allow', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1643', null, 'edit', '2013-05-01 11:02:19', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'false', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1644', null, 'edit', '2013-05-01 11:02:19', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1645', null, 'edit', '2013-05-01 11:02:19', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.password', 'Lwtcdi2! --encrypt', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1646', '1', 'delete', null, 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--delete-user', null, 'dedwards@sra.state.md.us', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1647', '1', 'add', '2013-05-01 11:34:09', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--add-user', null, 'dedwards@sra.state.md.us', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1648', null, 'edit', '2013-05-01 11:34:09', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.locality', 'external', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1649', null, 'edit', '2013-05-01 11:34:09', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.encryptMode', 'mandatory', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1650', null, 'edit', '2013-05-01 11:34:09', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'false', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1651', null, 'edit', '2013-05-01 11:34:09', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1652', null, 'edit', '2013-05-01 11:34:09', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.password', 'Lwtcdi2! --encrypt', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1653', '1', 'delete', null, 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--delete-user', null, 'dedwards@sra.state.md.us', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1654', '1', 'delete', null, 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--delete-user', null, 'janedoe@thepediatriccenter2.org', 'thepediatriccenter2.org', '1');
INSERT INTO `tasks` VALUES ('1655', '1', 'add', '2013-05-01 13:32:21', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--add-user', null, 'joe@thepediatriccenter2.org', 'thepediatriccenter2.org', '1');
INSERT INTO `tasks` VALUES ('1656', null, 'edit', '2013-05-01 13:32:21', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'joe@thepediatriccenter2.org', '1');
INSERT INTO `tasks` VALUES ('1657', null, 'edit', '2013-05-01 13:32:21', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'true', 'joe@thepediatriccenter2.org', '1');
INSERT INTO `tasks` VALUES ('1658', null, 'edit', '2013-05-01 13:32:21', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'joe@thepediatriccenter2.org', '1');
INSERT INTO `tasks` VALUES ('1659', '1', 'importcert', '2013-05-01 13:32:21', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '-import -pfx', 'ALREADY_SET', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/joe_thepediatriccenter2.org.pfx', 'joe@thepediatriccenter2.org', '1');
INSERT INTO `tasks` VALUES ('1662', null, 'edit', '2013-05-01 13:38:29', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'joe@thepediatriccenter2.org', '1');
INSERT INTO `tasks` VALUES ('1663', null, 'edit', '2013-05-01 13:38:29', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'joe@thepediatriccenter2.org', '1');
INSERT INTO `tasks` VALUES ('1664', null, 'edit', '2013-05-01 13:38:29', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'false', 'joe@thepediatriccenter2.org', '1');
INSERT INTO `tasks` VALUES ('1665', '1', 'delete', null, 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--delete-user', null, 'mary@mydirectmail.net', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1666', '1', 'delete', null, 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--delete-user', null, 'kaitlyn@mydirectmail.net', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1667', '1', 'add', '2013-05-01 13:53:46', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--add-user', null, 'kaitlyn@mydirectmail.net', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1668', null, 'edit', '2013-05-01 13:53:46', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1669', null, 'edit', '2013-05-01 13:53:46', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1670', null, 'edit', '2013-05-01 13:53:46', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1671', '1', 'importcert', '2013-05-01 13:53:46', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '-import -pfx', 'ALREADY_SET', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/kaitlyn_mydirectmail.net.pfx', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1672', null, 'edit', '2013-05-01 14:01:15', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1673', null, 'edit', '2013-05-01 14:01:15', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1681', null, 'edit', '2013-05-01 14:28:27', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1682', null, 'edit', '2013-05-01 14:28:27', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1683', null, 'edit', '2013-05-01 14:28:27', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1684', null, 'edit', '2013-05-01 14:30:48', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1678', null, 'edit', '2013-05-01 14:08:15', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1679', null, 'edit', '2013-05-01 14:08:15', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1680', null, 'edit', '2013-05-01 14:08:15', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--domain', '--set-property', 'user.sendEncryptionNotification', 'false', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1685', null, 'edit', '2013-05-01 14:30:48', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1686', null, 'edit', '2013-05-01 14:30:48', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1687', null, 'edit', '2013-05-01 14:32:17', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1688', null, 'edit', '2013-05-01 14:32:17', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1689', null, 'edit', '2013-05-01 14:32:17', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'false', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1690', null, 'edit', '2013-05-01 14:32:39', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1691', null, 'edit', '2013-05-01 14:32:39', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1692', null, 'edit', '2013-05-01 14:32:39', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1693', null, 'edit', '2013-05-01 14:35:51', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1694', null, 'edit', '2013-05-01 14:35:51', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1695', null, 'edit', '2013-05-01 14:35:51', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'false', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1696', null, 'edit', '2013-05-01 14:36:51', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1697', null, 'edit', '2013-05-01 14:36:51', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1698', null, 'edit', '2013-05-01 14:36:51', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1705', null, 'edit', '2013-05-01 14:46:36', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1706', null, 'edit', '2013-05-01 14:46:36', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1701', null, 'edit', '2013-05-01 14:43:13', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'false', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1707', null, 'edit', '2013-05-01 14:46:36', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'false', 'kaitlyn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1708', null, 'edit', '2013-05-01 14:48:21', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'joe@thepediatriccenter2.org', '1');
INSERT INTO `tasks` VALUES ('1709', null, 'edit', '2013-05-01 14:48:21', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'joe@thepediatriccenter2.org', '1');
INSERT INTO `tasks` VALUES ('1710', null, 'edit', '2013-05-01 14:48:21', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'false', 'joe@thepediatriccenter2.org', '1');
INSERT INTO `tasks` VALUES ('1711', null, 'edit', '2013-05-01 14:49:31', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'joe@thepediatriccenter2.org', '1');
INSERT INTO `tasks` VALUES ('1712', null, 'edit', '2013-05-01 14:49:31', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'joe@thepediatriccenter2.org', '1');
INSERT INTO `tasks` VALUES ('1713', null, 'edit', '2013-05-01 14:49:31', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'true', 'joe@thepediatriccenter2.org', '1');
INSERT INTO `tasks` VALUES ('1714', '1', 'add', '2013-05-02 09:13:45', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--add-user', null, 'dedwards@sra.state.md.us', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1715', null, 'edit', '2013-05-02 09:13:45', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.locality', 'external', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1716', null, 'edit', '2013-05-02 09:13:45', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.encryptMode', 'mandatory', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1717', null, 'edit', '2013-05-02 09:13:45', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'false', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1718', null, 'edit', '2013-05-02 09:13:45', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1719', null, 'edit', '2013-05-02 09:13:45', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.passwordsSendToOriginator', 'true', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1720', null, 'edit', '2013-05-02 09:13:45', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.passwordValidityInterval', '3600000', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1721', null, 'edit', '2013-05-02 09:13:45', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.passwordLength', '20', 'dedwards@sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1722', null, 'edit', '2013-05-08 13:33:33', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'dino.edwards@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1723', null, 'edit', '2013-05-08 13:33:33', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'dino.edwards@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1724', null, 'edit', '2013-05-08 13:33:33', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'false', 'dino.edwards@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1725', null, 'edit', '2013-05-08 13:35:42', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'zach@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1726', null, 'edit', '2013-05-08 13:35:42', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'zach@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1727', null, 'edit', '2013-05-08 13:35:42', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'false', 'zach@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1728', '1', 'add', '2013-05-09 11:29:08', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--add-user', null, 'dedwards@glaucomaexpert.com', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1729', null, 'edit', '2013-05-09 11:29:08', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.locality', 'external', 'dedwards@glaucomaexpert.com', '1');
INSERT INTO `tasks` VALUES ('1730', null, 'edit', '2013-05-09 11:29:08', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'dedwards@glaucomaexpert.com', '1');
INSERT INTO `tasks` VALUES ('1731', null, 'edit', '2013-05-09 11:29:08', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'dedwards@glaucomaexpert.com', '1');
INSERT INTO `tasks` VALUES ('1732', '1', 'importcert', '2013-05-09 11:29:08', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '-import -pfx', 'ALREADY_SET', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/dedwardsglaucomaexpertcom.pfx', 'dedwards@glaucomaexpert.com', '1');
INSERT INTO `tasks` VALUES ('1733', null, 'edit', '2013-05-09 11:29:08', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.encryptMode', 'mandatory', 'dedwards@glaucomaexpert.com', '1');
INSERT INTO `tasks` VALUES ('1734', '1', 'edit', '2013-05-09 11:33:36', 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--email', '--set-property', 'user.sMIMEEnabled', 'false', 'dedwards@glaucomaexpert.com', '1');
INSERT INTO `tasks` VALUES ('1735', '1', 'delete', null, 'e06a17d4-1ac6-45eb-b330-de86e3707f42', '--user', '--delete-user', null, 'dedwards@glaucomaexpert.com', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('1736', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1737', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1738', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1739', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1740', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1741', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1742', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1743', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1744', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1745', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1746', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1747', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1748', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1749', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1750', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1751', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1752', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1753', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1754', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1755', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1756', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1757', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1758', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1759', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1760', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1761', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1762', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1763', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1764', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1765', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1766', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra1.state.md.us', 'sra1.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1767', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra1.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1768', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra1.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1769', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra1.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1770', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra1.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1771', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra5.state.md.us', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1772', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1773', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1774', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1775', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1776', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1777', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1778', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1779', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1780', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1781', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra7.state.md.us', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1782', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1783', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1784', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1785', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1786', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1787', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1788', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1789', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1790', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1791', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra7.state.md.us', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1792', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1793', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1794', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1795', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1796', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1797', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1798', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1799', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1800', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1801', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra7.state.md.us', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1802', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1803', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1804', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1805', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1806', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1807', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1808', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1809', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1810', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1811', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra7.state.md.us', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1812', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1813', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1814', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1815', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1816', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1817', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1818', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1819', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1820', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1821', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra7.state.md.us', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1822', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1823', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1824', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1825', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1826', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1827', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1828', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1829', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1830', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1831', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra7.state.md.us', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1832', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1833', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1834', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1835', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1836', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1837', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1838', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1839', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1840', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1841', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra7.state.md.us', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1842', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1843', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1844', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1845', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1846', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1847', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1848', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1849', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1850', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1851', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra7.state.md.us', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1852', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1853', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1854', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1855', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1856', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1857', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1858', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1859', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1860', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1861', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra8.state.md.us', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1862', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1863', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1864', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1865', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1866', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra8.state.md.us', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1867', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1868', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1869', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1870', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1871', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra8.state.md.us', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1872', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1873', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1874', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1875', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1876', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra8.state.md.us', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1877', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1878', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1879', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1880', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1881', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra8.state.md.us', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1882', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1883', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1884', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1885', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1886', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra8.state.md.us', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1887', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1888', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1889', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1890', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1891', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra8.state.md.us', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1892', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1893', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1894', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1895', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1896', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra7.state.md.us', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1897', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1898', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1899', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1900', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1901', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1902', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1903', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1904', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1905', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1906', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra8.state.md.us', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1907', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1908', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1909', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1910', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1911', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra8.state.md.us', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1912', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1913', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1914', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1915', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1916', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra7.state.md.us', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1917', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1918', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1919', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1920', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1921', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1922', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1923', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1924', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1925', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1926', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra8.state.md.us', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1927', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1928', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1929', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1930', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1931', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra7.state.md.us', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1932', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1933', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1934', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1935', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1936', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1937', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1938', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1939', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1940', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1941', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra8.state.md.us', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1942', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1943', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1944', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1945', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1946', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra7.state.md.us', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1947', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1948', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1949', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1950', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1951', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1952', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1953', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1954', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1955', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1956', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra8.state.md.us', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1957', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1958', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1959', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1960', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1961', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra7.state.md.us', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1962', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1963', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1964', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1965', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1966', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1967', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1968', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1969', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1970', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1971', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra8.state.md.us', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1972', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1973', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1974', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1975', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1976', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra9.state.md.us', 'sra9.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1977', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra9.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1978', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra9.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1979', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra9.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1980', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra9.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1981', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra10.state.md.us', 'sra10.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1982', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra10.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1983', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra10.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1984', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra10.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1985', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra10.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1986', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra11.state.md.us', 'sra11.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1987', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra11.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1988', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra11.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1989', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra11.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1990', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra11.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1991', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra12.state.md.us', 'sra12.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1992', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra12.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1993', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra12.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1994', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra12.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1995', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra12.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1996', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra13.state.md.us', 'sra13.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1997', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra13.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1998', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra13.state.md.us', '1');
INSERT INTO `tasks` VALUES ('1999', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra13.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2000', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra13.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2001', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra14.state.md.us', 'sra14.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2002', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra14.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2003', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra14.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2004', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra14.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2005', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra14.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2006', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra15.state.md.us', 'sra15.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2007', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra15.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2008', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra15.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2009', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra15.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2010', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra15.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2011', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra7.state.md.us', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2012', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2013', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2014', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2015', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2016', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2017', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2018', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2019', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2020', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2021', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra8.state.md.us', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2022', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2023', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2024', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2025', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2026', null, 'edit', '2013-05-24 16:20:56', '8e5c18fe-b6e6-4d5a-83e5-58c9e80b8052', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'dino.edwards@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2027', null, 'edit', '2013-05-24 16:20:56', '8e5c18fe-b6e6-4d5a-83e5-58c9e80b8052', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'dino.edwards@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2028', null, 'edit', '2013-05-24 16:20:56', '8e5c18fe-b6e6-4d5a-83e5-58c9e80b8052', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'true', 'dino.edwards@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2029', '1', 'add', null, null, '--domain', '--add-domain', null, 'deeztek.net', 'deeztek.net', '1');
INSERT INTO `tasks` VALUES ('2030', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'deeztek.net', '1');
INSERT INTO `tasks` VALUES ('2031', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'deeztek.net', '1');
INSERT INTO `tasks` VALUES ('2032', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'deeztek.net', '1');
INSERT INTO `tasks` VALUES ('2033', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'deeztek.net', '1');
INSERT INTO `tasks` VALUES ('2034', '1', 'delete', null, 'a4e52d4a-2e74-442e-9805-f70cbdb1f421', '--user', '--delete-user', null, 'dedwards@deeztek.net', 'deeztek.net', '1');
INSERT INTO `tasks` VALUES ('2035', '1', 'add', '2013-06-03 12:53:48', '98a5d04f-55e5-4c3a-9c22-a175cfcf52e4', '--user', '--add-user', null, 'ddurante@medtec.net', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2036', null, 'edit', '2013-06-03 12:53:48', '98a5d04f-55e5-4c3a-9c22-a175cfcf52e4', '--email', '--set-property', 'user.locality', 'external', 'ddurante@medtec.net', '1');
INSERT INTO `tasks` VALUES ('2037', null, 'edit', '2013-06-03 12:53:48', '98a5d04f-55e5-4c3a-9c22-a175cfcf52e4', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'ddurante@medtec.net', '1');
INSERT INTO `tasks` VALUES ('2038', null, 'edit', '2013-06-03 12:53:48', '98a5d04f-55e5-4c3a-9c22-a175cfcf52e4', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'ddurante@medtec.net', '1');
INSERT INTO `tasks` VALUES ('2039', '1', 'importcert', '2013-06-03 12:53:48', '98a5d04f-55e5-4c3a-9c22-a175cfcf52e4', '--user', '-import -pfx', 'ALREADY_SET', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/ddurantemedtecnet.pfx', 'ddurante@medtec.net', '1');
INSERT INTO `tasks` VALUES ('2040', null, 'edit', '2013-06-03 12:53:48', '98a5d04f-55e5-4c3a-9c22-a175cfcf52e4', '--email', '--set-property', 'user.encryptMode', 'mandatory', 'ddurante@medtec.net', '1');
INSERT INTO `tasks` VALUES ('2041', '1', 'add', null, null, '--domain', '--add-domain', null, 'mycomputersquad.com', 'mycomputersquad.com', '1');
INSERT INTO `tasks` VALUES ('2042', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'mycomputersquad.com', '1');
INSERT INTO `tasks` VALUES ('2043', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'mycomputersquad.com', '1');
INSERT INTO `tasks` VALUES ('2044', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'mycomputersquad.com', '1');
INSERT INTO `tasks` VALUES ('2045', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'mycomputersquad.com', '1');
INSERT INTO `tasks` VALUES ('2046', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'mycomputersquad.com', '1');
INSERT INTO `tasks` VALUES ('2047', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'mycomputersquad.com', '1');
INSERT INTO `tasks` VALUES ('2048', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'mycomputersquad.com', '1');
INSERT INTO `tasks` VALUES ('2049', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'mycomputersquad.com', '1');
INSERT INTO `tasks` VALUES ('2050', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'mycomputersquad.com', '1');
INSERT INTO `tasks` VALUES ('2051', '1', 'add', '2013-06-06 20:04:14', '70c915ca-909f-4f30-bdec-2f86f0305bb4', '--user', '--add-user', null, 'ddurante@mycomputersquad.com', 'mycomputersquad.com', '1');
INSERT INTO `tasks` VALUES ('2052', null, 'edit', '2013-06-06 20:04:14', '70c915ca-909f-4f30-bdec-2f86f0305bb4', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'ddurante@mycomputersquad.com', '1');
INSERT INTO `tasks` VALUES ('2053', null, 'edit', '2013-06-06 20:04:14', '70c915ca-909f-4f30-bdec-2f86f0305bb4', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'true', 'ddurante@mycomputersquad.com', '1');
INSERT INTO `tasks` VALUES ('2054', null, 'edit', '2013-06-06 20:04:14', '70c915ca-909f-4f30-bdec-2f86f0305bb4', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'ddurante@mycomputersquad.com', '1');
INSERT INTO `tasks` VALUES ('2055', '1', 'importcert', '2013-06-06 20:04:14', '70c915ca-909f-4f30-bdec-2f86f0305bb4', '--user', '-import -pfx', 'ALREADY_SET', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/ddurante_mycomputersquad.com.pfx', 'ddurante@mycomputersquad.com', '1');
INSERT INTO `tasks` VALUES ('2056', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra15.state.md.us', 'sra15.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2057', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra15.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2058', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra15.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2059', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra15.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2060', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra15.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2061', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra14.state.md.us', 'sra14.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2062', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra14.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2063', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra14.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2064', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra14.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2065', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra14.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2066', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra13.state.md.us', 'sra13.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2067', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra13.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2068', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra13.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2069', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra13.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2070', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra13.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2071', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra12.state.md.us', 'sra12.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2072', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra12.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2073', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra12.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2074', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra12.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2075', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra12.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2076', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra11.state.md.us', 'sra11.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2077', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra11.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2078', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra11.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2079', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra11.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2080', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra11.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2081', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra10.state.md.us', 'sra10.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2082', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra10.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2083', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra10.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2084', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra10.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2085', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra10.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2086', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra9.state.md.us', 'sra9.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2087', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra9.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2088', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra9.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2089', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra9.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2090', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra9.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2091', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra1.state.md.us', 'sra1.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2092', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra1.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2093', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra1.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2094', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra1.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2095', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra1.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2096', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra8.state.md.us', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2097', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2098', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2099', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2100', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra8.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2101', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra7.state.md.us', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2102', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2103', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2104', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2105', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2106', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2107', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2108', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2109', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2110', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra7.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2111', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra5.state.md.us', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2112', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2113', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2114', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2115', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2116', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2117', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2118', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2119', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2120', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra5.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2121', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra4.state.md.us', 'sra4.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2122', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra4.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2123', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra4.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2124', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra4.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2125', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra4.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2126', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra3.state.md.us', 'sra3.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2127', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra3.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2128', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra3.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2129', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra3.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2130', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra3.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2131', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra2.state.md.us', 'sra2.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2132', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra2.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2133', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra2.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2134', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra2.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2135', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra2.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2136', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2137', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2138', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2139', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2140', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2141', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2142', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2143', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2144', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2145', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2146', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2147', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2148', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2149', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2150', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2151', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2152', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2153', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2154', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2155', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2156', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2157', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2158', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2159', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2160', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2161', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2162', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2163', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2164', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2165', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2166', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2167', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2168', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2169', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2170', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2171', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2172', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2173', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2174', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2175', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2176', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2177', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2178', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2179', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2180', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2181', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2182', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2183', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2184', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2185', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2186', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2187', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2188', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2189', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2190', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2191', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2192', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2193', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2194', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2195', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2196', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2197', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2198', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2199', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2200', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2201', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2202', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2203', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2204', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2205', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2206', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2207', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2208', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2209', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2210', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2211', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2212', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2213', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2214', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2215', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2216', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2217', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2218', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2219', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2220', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2221', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2222', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2223', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2224', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2225', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2226', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2227', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2228', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2229', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2230', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2231', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2232', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2233', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2234', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2235', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2236', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2237', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2238', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2239', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2240', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2241', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2242', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2243', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2244', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2245', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2246', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2247', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2248', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2249', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2250', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2251', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2252', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2253', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2254', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2255', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2256', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2257', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2258', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2259', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2260', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2261', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2262', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2263', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2264', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2265', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2266', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2267', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2268', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2269', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2270', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2271', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2272', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2273', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2274', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2275', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2276', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2277', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2278', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2279', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2280', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2281', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2282', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2283', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2284', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2285', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2286', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2287', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2288', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2289', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2290', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2291', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2292', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2293', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2294', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2295', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2296', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2297', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2298', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2299', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2300', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2301', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2302', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2303', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2304', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2305', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2306', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2307', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2308', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2309', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2310', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2311', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2312', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2313', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2314', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2315', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2316', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2317', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2318', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2319', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2320', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2321', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2322', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2323', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2324', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2325', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2326', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2327', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2328', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2329', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2330', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2331', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2332', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2333', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2334', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2335', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2336', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2337', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2338', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2339', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2340', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2341', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2342', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2343', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2344', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2345', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2346', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2347', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2348', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2349', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2350', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2351', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2352', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2353', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2354', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2355', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2356', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2357', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2358', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2359', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2360', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2361', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2362', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2363', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2364', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2365', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2366', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2367', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2368', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2369', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2370', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2371', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2372', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2373', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2374', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2375', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2376', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2377', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2378', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2379', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2380', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2381', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2382', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2383', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2384', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2385', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2386', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2387', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2388', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2389', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2390', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2391', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2392', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2393', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2394', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2395', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2396', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2397', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2398', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2399', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2400', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2401', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2402', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2403', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2404', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2405', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2406', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2407', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2408', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2409', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2410', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2411', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2412', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2413', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2414', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2415', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2416', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2417', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2418', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2419', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2420', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2421', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2422', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2423', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2424', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2425', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2426', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2427', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2428', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2429', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2430', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2431', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2432', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2433', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2434', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2435', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2436', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2437', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2438', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2439', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2440', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2441', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2442', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2443', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2444', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2445', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2446', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2447', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2448', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2449', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2450', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2451', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2452', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2453', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2454', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2455', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2456', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2457', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2458', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2459', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2460', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2461', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2462', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2463', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2464', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2465', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2466', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2467', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2468', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2469', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2470', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2471', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2472', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2473', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2474', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2475', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2476', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2477', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2478', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2479', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2480', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2481', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2482', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2483', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2485', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2486', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2487', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2488', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2489', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2490', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2491', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2492', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2493', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2494', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2495', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2496', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2497', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2498', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2499', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2500', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2501', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2502', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2503', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2504', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2505', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2506', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2507', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2508', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2509', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2510', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2511', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2512', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2513', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2514', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2515', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2516', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2517', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2518', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2519', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2520', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2521', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2522', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2523', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2524', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2525', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2526', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2527', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2528', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2529', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2530', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2531', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2532', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2533', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2534', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2535', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2536', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2537', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2538', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2539', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2540', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2541', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2542', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2543', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2544', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2545', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2546', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2547', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2548', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2549', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2550', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2551', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2552', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2553', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2554', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2555', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2556', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2557', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2558', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2559', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2560', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2561', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2562', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2563', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2564', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2565', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2566', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2567', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2568', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2569', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2570', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2571', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2572', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2573', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2574', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2575', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2576', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2577', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2578', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2579', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2580', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2581', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2582', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2583', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2584', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2585', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2586', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2587', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2588', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2589', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2590', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2591', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2592', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2593', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2594', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2595', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2596', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2597', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2598', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2599', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2600', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2601', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2602', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2603', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2604', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2605', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2606', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2607', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2608', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2609', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2610', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2611', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2612', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2613', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2614', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2615', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2616', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2617', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2618', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2619', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2620', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2621', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2622', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2623', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2624', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2625', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2626', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2627', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2628', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2629', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2630', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2631', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2632', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2633', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2634', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2635', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2636', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2637', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2638', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2639', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2640', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2641', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2642', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2643', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2644', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2645', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2646', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2647', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2648', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2649', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2650', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2651', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2652', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2653', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2654', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2655', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2656', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2657', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2658', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2659', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2660', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2661', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2662', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2663', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2664', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2665', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2666', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2667', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2668', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2669', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2670', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2671', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2672', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2673', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2674', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2675', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2676', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2677', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2678', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2679', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2680', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2681', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2682', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2683', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2684', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2685', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2686', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2687', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2688', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2689', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2690', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2691', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2692', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2693', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2694', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2695', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2696', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2697', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2698', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2699', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2700', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2701', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2702', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2703', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2704', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2705', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2706', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2707', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2708', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2709', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2710', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2711', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2712', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2713', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2714', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2715', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2716', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2717', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2718', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2719', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2720', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2721', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2722', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2723', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2724', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2725', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2726', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2727', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2728', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2729', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2730', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2731', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2732', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2733', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2734', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2735', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2736', '1', 'add', null, null, '--domain', '--add-domain', null, 'sra.state.md.us', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2737', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2738', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2739', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2740', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2741', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2742', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2743', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2744', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2745', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'sra.state.md.us', '1');
INSERT INTO `tasks` VALUES ('2746', '1', 'add', '2013-06-16 11:55:13', '859649f6-fadd-420f-bae2-4b48ebea93dc', '--user', '--add-user', null, 'caflynn@mydirectmail.net', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2747', null, 'edit', '2013-06-16 11:55:13', '859649f6-fadd-420f-bae2-4b48ebea93dc', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'caflynn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2748', null, 'edit', '2013-06-16 11:55:13', '859649f6-fadd-420f-bae2-4b48ebea93dc', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'true', 'caflynn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2749', null, 'edit', '2013-06-16 11:55:13', '859649f6-fadd-420f-bae2-4b48ebea93dc', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'caflynn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2750', '1', 'importcert', '2013-06-16 11:55:13', '859649f6-fadd-420f-bae2-4b48ebea93dc', '--user', '-import -pfx', 'ALREADY_SET', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/caflynn_mydirectmail.net.pfx', 'caflynn@mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2751', '1', 'add', '2013-07-17 16:41:13', '98a5d04f-55e5-4c3a-9c22-a175cfcf52e4', '--user', '--add-user', null, 'sbolander@rop.com', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2752', null, 'edit', '2013-07-17 16:41:13', '98a5d04f-55e5-4c3a-9c22-a175cfcf52e4', '--email', '--set-property', 'user.locality', 'external', 'sbolander@rop.com', '1');
INSERT INTO `tasks` VALUES ('2753', null, 'edit', '2013-07-17 16:41:13', '98a5d04f-55e5-4c3a-9c22-a175cfcf52e4', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'sbolander@rop.com', '1');
INSERT INTO `tasks` VALUES ('2754', null, 'edit', '2013-07-17 16:41:13', '98a5d04f-55e5-4c3a-9c22-a175cfcf52e4', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'sbolander@rop.com', '1');
INSERT INTO `tasks` VALUES ('2755', '1', 'importcert', '2013-07-17 16:41:13', '98a5d04f-55e5-4c3a-9c22-a175cfcf52e4', '--user', '-import -pfx', 'ALREADY_SET', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/sbolanderropcom.pfx', 'sbolander@rop.com', '1');
INSERT INTO `tasks` VALUES ('2756', null, 'edit', '2013-07-17 16:41:13', '98a5d04f-55e5-4c3a-9c22-a175cfcf52e4', '--email', '--set-property', 'user.encryptMode', 'mandatory', 'sbolander@rop.com', '1');
INSERT INTO `tasks` VALUES ('2757', '1', 'delete', null, '98a5d04f-55e5-4c3a-9c22-a175cfcf52e4', '--user', '--delete-user', null, 'dedwards@sra.state.md.us', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2758', '1', 'add', null, null, '--domain', '--add-domain', null, 'aol.com', 'aol.com', '1');
INSERT INTO `tasks` VALUES ('2759', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'aol.com', '1');
INSERT INTO `tasks` VALUES ('2760', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'aol.com', '1');
INSERT INTO `tasks` VALUES ('2761', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'aol.com', '1');
INSERT INTO `tasks` VALUES ('2762', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'aol.com', '1');
INSERT INTO `tasks` VALUES ('2763', '1', 'add', null, null, '--domain', '--add-domain', null, 'aol.com', 'aol.com', '1');
INSERT INTO `tasks` VALUES ('2764', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'aol.com', '1');
INSERT INTO `tasks` VALUES ('2765', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'aol.com', '1');
INSERT INTO `tasks` VALUES ('2766', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'aol.com', '1');
INSERT INTO `tasks` VALUES ('2767', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'aol.com', '1');
INSERT INTO `tasks` VALUES ('2768', '1', 'add', null, null, '--domain', '--add-domain', null, 'aol2.com', 'aol2.com', '1');
INSERT INTO `tasks` VALUES ('2769', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'aol2.com', '1');
INSERT INTO `tasks` VALUES ('2770', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'aol2.com', '1');
INSERT INTO `tasks` VALUES ('2771', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'aol2.com', '1');
INSERT INTO `tasks` VALUES ('2772', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'aol2.com', '1');
INSERT INTO `tasks` VALUES ('2773', '1', 'add', null, null, '--domain', '--add-domain', null, 'aol3.com', 'aol3.com', '1');
INSERT INTO `tasks` VALUES ('2774', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'aol3.com', '1');
INSERT INTO `tasks` VALUES ('2775', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'aol3.com', '1');
INSERT INTO `tasks` VALUES ('2776', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'aol3.com', '1');
INSERT INTO `tasks` VALUES ('2777', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'aol3.com', '1');
INSERT INTO `tasks` VALUES ('2778', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'aol3.com', '1');
INSERT INTO `tasks` VALUES ('2779', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'aol3.com', '1');
INSERT INTO `tasks` VALUES ('2780', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'aol3.com', '1');
INSERT INTO `tasks` VALUES ('2781', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'aol3.com', '1');
INSERT INTO `tasks` VALUES ('2782', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'aol3.com', '1');
INSERT INTO `tasks` VALUES ('2783', '1', 'delete', null, 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--user', '--delete-user', null, 'kaitlyn@mydirectmail.net', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2784', '1', 'delete', null, 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--user', '--delete-user', null, 'caflynn@mydirectmail.net', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2785', '1', 'delete', null, 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--user', '--delete-user', null, 'zach@mydirectmail.net', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2786', '1', 'add', '2013-10-13 17:55:51', 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--user', '--add-user', null, 'ca301980@gmail.com', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2787', null, 'edit', '2013-10-13 17:55:51', 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--email', '--set-property', 'user.locality', 'external', 'ca301980@gmail.com', '1');
INSERT INTO `tasks` VALUES ('2788', null, 'edit', '2013-10-13 17:55:51', 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'ca301980@gmail.com', '1');
INSERT INTO `tasks` VALUES ('2789', null, 'edit', '2013-10-13 17:55:51', 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'ca301980@gmail.com', '1');
INSERT INTO `tasks` VALUES ('2790', '1', 'importcert', '2013-10-13 17:55:51', 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--user', '-import -pfx', 'ALREADY_SET', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/ca301980gmailcom.pfx', 'ca301980@gmail.com', '1');
INSERT INTO `tasks` VALUES ('2791', null, 'edit', '2013-10-13 17:55:51', 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--email', '--set-property', 'user.encryptMode', 'mandatory', 'ca301980@gmail.com', '1');
INSERT INTO `tasks` VALUES ('2792', '1', 'delete', null, 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--user', '--delete-user', null, 'ca301980@gmail.com', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2793', '1', 'add', '2013-10-13 18:11:05', 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--user', '--add-user', null, 'canymd@zoominternet.net', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2794', null, 'edit', '2013-10-13 18:11:05', 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--email', '--set-property', 'user.locality', 'external', 'canymd@zoominternet.net', '1');
INSERT INTO `tasks` VALUES ('2795', null, 'edit', '2013-10-13 18:11:05', 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'canymd@zoominternet.net', '1');
INSERT INTO `tasks` VALUES ('2796', null, 'edit', '2013-10-13 18:11:05', 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'canymd@zoominternet.net', '1');
INSERT INTO `tasks` VALUES ('2797', '1', 'importcert', '2013-10-13 18:11:05', 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--user', '-import -pfx', 'ALREADY_SET', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/canymdzoominternetnet.pfx', 'canymd@zoominternet.net', '1');
INSERT INTO `tasks` VALUES ('2798', null, 'edit', '2013-10-13 18:11:05', 'd6e5a6d1-ae44-4132-a403-8528001750c4', '--email', '--set-property', 'user.encryptMode', 'mandatory', 'canymd@zoominternet.net', '1');
INSERT INTO `tasks` VALUES ('2799', '1', 'delete', null, 'fcde1137-6445-4847-8062-2c6998960f02', '--user', '--delete-user', null, 'canymd@zoominternet.net', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2800', '1', 'add', '2013-10-19 16:16:00', 'fcde1137-6445-4847-8062-2c6998960f02', '--user', '--add-user', null, 'scott@cincysystems.com', 'mydirectmail.net', '1');
INSERT INTO `tasks` VALUES ('2801', null, 'edit', '2013-10-19 16:16:00', 'fcde1137-6445-4847-8062-2c6998960f02', '--email', '--set-property', 'user.locality', 'external', 'scott@cincysystems.com', '1');
INSERT INTO `tasks` VALUES ('2802', null, 'edit', '2013-10-19 16:16:00', 'fcde1137-6445-4847-8062-2c6998960f02', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'scott@cincysystems.com', '1');
INSERT INTO `tasks` VALUES ('2803', null, 'edit', '2013-10-19 16:16:00', 'fcde1137-6445-4847-8062-2c6998960f02', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'scott@cincysystems.com', '1');
INSERT INTO `tasks` VALUES ('2804', '1', 'importcert', '2013-10-19 16:16:00', 'fcde1137-6445-4847-8062-2c6998960f02', '--user', '-import -pfx', 'ALREADY_SET', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/scottcincysystemscom.pfx', 'scott@cincysystems.com', '1');
INSERT INTO `tasks` VALUES ('2805', null, 'edit', '2013-10-19 16:16:00', 'fcde1137-6445-4847-8062-2c6998960f02', '--email', '--set-property', 'user.encryptMode', 'mandatory', 'scott@cincysystems.com', '1');
INSERT INTO `tasks` VALUES ('2806', '1', 'edit', null, null, '--email', '--set-property', 'user.password', 'Lwtcdi2! --encrypt', 'bob@aol.com', '2');
INSERT INTO `tasks` VALUES ('2807', '1', 'edit', null, null, '--email', '--set-property', 'user.passwordsSendToOriginator', 'true', 'deeztek@hotmail.com', '2');
INSERT INTO `tasks` VALUES ('2808', '1', 'edit', null, null, '--email', '--set-property', 'user.passwordValidityInterval', '3600000', 'deeztek@hotmail.com', '2');
INSERT INTO `tasks` VALUES ('2809', '1', 'edit', null, null, '--email', '--set-property', 'user.passwordLength', '160', 'deeztek@hotmail.com', '2');
INSERT INTO `tasks` VALUES ('2810', '1', 'delete', null, '437c2e76-31ce-403d-a4c4-b15ac359fcf3', '--user', '--delete-user', null, 'rob@deeztek.com', 'deeztek.com', '2');
INSERT INTO `tasks` VALUES ('2811', '1', 'delete', null, '437c2e76-31ce-403d-a4c4-b15ac359fcf3', '--user', '--delete-user', null, 'lucy@deeztek.com', 'deeztek.com', '2');
INSERT INTO `tasks` VALUES ('2812', '1', 'delete', null, '437c2e76-31ce-403d-a4c4-b15ac359fcf3', '--user', '--delete-user', null, 'GTtekai@deeztek.com', 'deeztek.com', '2');
INSERT INTO `tasks` VALUES ('2813', '1', 'delete', null, '437c2e76-31ce-403d-a4c4-b15ac359fcf3', '--user', '--delete-user', null, 'gtekai@deeztek.com', 'deeztek.com', '2');
INSERT INTO `tasks` VALUES ('2814', '1', 'add', null, null, '--domain', '--add-domain', null, 'setonpainrehab.com', 'setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2815', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2816', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2817', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2818', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2819', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2820', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2821', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2822', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2823', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2824', '1', 'add', null, null, '--domain', '--add-domain', null, 'setonpainrehab2.com', 'setonpainrehab2.com', '2');
INSERT INTO `tasks` VALUES ('2825', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'setonpainrehab2.com', '2');
INSERT INTO `tasks` VALUES ('2826', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'setonpainrehab2.com', '2');
INSERT INTO `tasks` VALUES ('2827', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'setonpainrehab2.com', '2');
INSERT INTO `tasks` VALUES ('2828', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'setonpainrehab2.com', '2');
INSERT INTO `tasks` VALUES ('2829', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'setonpainrehab2.com', '2');
INSERT INTO `tasks` VALUES ('2830', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'setonpainrehab2.com', '2');
INSERT INTO `tasks` VALUES ('2831', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'setonpainrehab2.com', '2');
INSERT INTO `tasks` VALUES ('2832', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'setonpainrehab2.com', '2');
INSERT INTO `tasks` VALUES ('2833', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'setonpainrehab2.com', '2');
INSERT INTO `tasks` VALUES ('2834', '1', 'add', '2014-05-06 10:00:23', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--user', '--add-user', null, 'drward@setonpainrehab.com', 'setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2835', null, 'edit', '2014-05-06 10:00:23', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'drward@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2836', null, 'edit', '2014-05-06 10:00:23', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'true', 'drward@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2837', null, 'edit', '2014-05-06 10:00:23', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'drward@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2838', '1', 'importcert', '2014-05-06 10:00:23', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--user', '-import -pfx', 'ChangeMe2!', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/drward_setonpainrehab.com.pfx', 'drward@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2839', '1', 'add', '2014-05-06 10:04:06', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--user', '--add-user', null, 'drdekker@setonpainrehab.com', 'setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2840', null, 'edit', '2014-05-06 10:04:06', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'drdekker@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2841', null, 'edit', '2014-05-06 10:04:06', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'true', 'drdekker@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2842', null, 'edit', '2014-05-06 10:04:06', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'drdekker@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2843', '1', 'importcert', '2014-05-06 10:04:06', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--user', '-import -pfx', 'ChangeMe2!', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/drdekker_setonpainrehab.com.pfx', 'drdekker@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2844', '1', 'add', '2014-05-06 10:05:12', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--user', '--add-user', null, 'rschneller@setonpainrehab.com', 'setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2845', null, 'edit', '2014-05-06 10:05:12', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'rschneller@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2846', null, 'edit', '2014-05-06 10:05:12', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'true', 'rschneller@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2847', null, 'edit', '2014-05-06 10:05:12', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'rschneller@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2848', '1', 'importcert', '2014-05-06 10:05:12', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--user', '-import -pfx', 'ChangeMe2!', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/rschneller_setonpainrehab.com.pfx', 'rschneller@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2849', '1', 'add', '2014-05-06 10:06:45', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--user', '--add-user', null, 'abrewton@setonpainrehab.com', 'setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2850', null, 'edit', '2014-05-06 10:06:45', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--email', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'abrewton@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2851', null, 'edit', '2014-05-06 10:06:45', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--email', '--set-property', 'user.onlySignWhenEncrypt', 'true', 'abrewton@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2852', null, 'edit', '2014-05-06 10:06:45', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--email', '--set-property', 'user.sMIMEEnabled', 'true', 'abrewton@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2853', '1', 'importcert', '2014-05-06 10:06:45', 'b3afd7fc-9cbd-4772-b712-03c04c5da8f7', '--user', '-import -pfx', 'ChangeMe2!', '/opt/railo/tomcat/webapps/ROOT/tasks/PFX/abrewton_setonpainrehab.com.pfx', 'abrewton@setonpainrehab.com', '2');
INSERT INTO `tasks` VALUES ('2854', '1', 'add', null, null, '--domain', '--add-domain', null, 'pcdocmd.com', 'pcdocmd.com', '2');
INSERT INTO `tasks` VALUES ('2855', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'pcdocmd.com', '2');
INSERT INTO `tasks` VALUES ('2856', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'pcdocmd.com', '2');
INSERT INTO `tasks` VALUES ('2857', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'pcdocmd.com', '2');
INSERT INTO `tasks` VALUES ('2858', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'pcdocmd.com', '2');
INSERT INTO `tasks` VALUES ('2859', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'pcdocmd.com', '2');
INSERT INTO `tasks` VALUES ('2860', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'pcdocmd.com', '2');
INSERT INTO `tasks` VALUES ('2861', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'pcdocmd.com', '2');
INSERT INTO `tasks` VALUES ('2862', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'pcdocmd.com', '2');
INSERT INTO `tasks` VALUES ('2863', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'pcdocmd.com', '2');
INSERT INTO `tasks` VALUES ('2864', '1', 'add', null, null, '--domain', '--add-domain', null, 'bolanderhome.com', 'bolanderhome.com', '2');
INSERT INTO `tasks` VALUES ('2865', '1', 'edit', null, null, '--domain', '--set-property', 'user.locality', 'internal', 'bolanderhome.com', '2');
INSERT INTO `tasks` VALUES ('2866', '1', 'edit', null, null, '--domain', '--set-property', 'user.encryptMode', 'noEncryption', 'bolanderhome.com', '2');
INSERT INTO `tasks` VALUES ('2867', '1', 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'false', 'bolanderhome.com', '2');
INSERT INTO `tasks` VALUES ('2868', '1', 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'false', 'bolanderhome.com', '2');
INSERT INTO `tasks` VALUES ('2869', null, 'edit', null, null, '--domain', '--set-property', 'user.pdf.encryptionAllowed', 'true', 'bolanderhome.com', '2');
INSERT INTO `tasks` VALUES ('2870', null, 'edit', null, null, '--domain', '--set-property', 'user.sMIMEEnabled', 'true', 'bolanderhome.com', '2');
INSERT INTO `tasks` VALUES ('2871', null, 'edit', null, null, '--domain', '--set-property', 'user.sendEncryptionNotification', 'true', 'bolanderhome.com', '2');
INSERT INTO `tasks` VALUES ('2872', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTriggerEnabled', 'true', 'bolanderhome.com', '2');
INSERT INTO `tasks` VALUES ('2873', null, 'edit', null, null, '--domain', '--set-property', 'user.subjectTrigger', '[encrypt]', 'bolanderhome.com', '2');

-- ----------------------------
-- Table structure for `tasks2`
-- ----------------------------
DROP TABLE IF EXISTS `tasks2`;
CREATE TABLE `tasks2` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `priority` int(11) DEFAULT NULL,
  `domain` varchar(255) DEFAULT NULL,
  `server` varchar(255) DEFAULT NULL,
  `date_time_submitted` timestamp NULL DEFAULT NULL,
  `session_no` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `command` varchar(255) DEFAULT NULL,
  `completed` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=961 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of tasks2
-- ----------------------------
INSERT INTO `tasks2` VALUES ('953', null, 'aol.com smtp:[192.168.10.238]', null, null, null, 'transport', null, '1');
INSERT INTO `tasks2` VALUES ('955', null, 'aol2.com smtp:[192.168.10.238]', null, null, null, 'transport', null, '1');
INSERT INTO `tasks2` VALUES ('956', null, 'aol3.com smtp:[192.168.10.201]', null, null, null, 'transport', null, '1');
INSERT INTO `tasks2` VALUES ('957', null, 'setonpainrehab.com smtp:[192.168.10.238]', null, null, null, 'transport', null, '2');
INSERT INTO `tasks2` VALUES ('958', null, 'setonpainrehab2.com smtp:[192.168.10.238]', null, null, null, 'transport', null, '2');
INSERT INTO `tasks2` VALUES ('959', null, 'pcdocmd.com smtp:[192.168.10.201]', null, null, null, 'transport', null, '2');
INSERT INTO `tasks2` VALUES ('960', null, 'bolanderhome.com smtp:[192.168.10.201]', null, null, null, 'transport', null, '2');

-- ----------------------------
-- Table structure for `temp_mail_view`
-- ----------------------------
DROP TABLE IF EXISTS `temp_mail_view`;
CREATE TABLE `temp_mail_view` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mail_text` longblob,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=149 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of temp_mail_view
-- ----------------------------

-- ----------------------------
-- Table structure for `temp_table`
-- ----------------------------
DROP TABLE IF EXISTS `temp_table`;
CREATE TABLE `temp_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(255) DEFAULT NULL,
  `djigzo_certificate_id` int(11) DEFAULT NULL,
  `recipient_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=52 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of temp_table
-- ----------------------------
INSERT INTO `temp_table` VALUES ('40', 'syiRBYcm', '69', '1238');
INSERT INTO `temp_table` VALUES ('41', 'ZAEdsKmC', '71', '1238');
INSERT INTO `temp_table` VALUES ('43', 'fPwvZnyE', '54', '130');
INSERT INTO `temp_table` VALUES ('44', '1vipjWcw', '69', '181');
INSERT INTO `temp_table` VALUES ('45', 'gYlwS5Jr', '69', '181');
INSERT INTO `temp_table` VALUES ('51', 'kQiUH8tV', '324', '1238');
INSERT INTO `temp_table` VALUES ('50', 'p8AsMhWv', '324', '1238');

-- ----------------------------
-- Table structure for `testing`
-- ----------------------------
DROP TABLE IF EXISTS `testing`;
CREATE TABLE `testing` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `company` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=164 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of testing
-- ----------------------------
INSERT INTO `testing` VALUES ('1', 'gicsgovt@invitrogen.com', 'gicsgovt', 'invitrogen.com');
INSERT INTO `testing` VALUES ('2', 'ahaeffner@ipmscientific.com', 'ahaeffner', 'ipmscientific.com');
INSERT INTO `testing` VALUES ('3', 'sales@labmart.com', 'sales', 'labmart.com');
INSERT INTO `testing` VALUES ('4', 'rbecraft@labmart.com', 'rbecraft', 'labmart.com');
INSERT INTO `testing` VALUES ('5', 'pmaus@kdmedical.com', 'pmaus', 'kdmedical.com');
INSERT INTO `testing` VALUES ('6', 'axu@keystonebionalytical.com', 'axu', 'keystonebionalytical.com');
INSERT INTO `testing` VALUES ('7', 'michael.norman@kcc.com', 'michael.norman', 'kcc.com');
INSERT INTO `testing` VALUES ('8', 'kops@erols.com', 'kops', 'erols.com');
INSERT INTO `testing` VALUES ('9', 'shellybundy@verizon.net', 'shellybundy', 'verizon.net');
INSERT INTO `testing` VALUES ('10', 'lfriedenthal@verizon.net', 'lfriedenthal', 'verizon.net');
INSERT INTO `testing` VALUES ('11', 'Linda@TheLabResource.com', 'Linda', 'TheLabresource.com');
INSERT INTO `testing` VALUES ('12', 'info@lsdcorp.com', 'info', 'lsdcorp.com');
INSERT INTO `testing` VALUES ('13', 'sbany@labsource.com', 'sbany', 'labsource.com');
INSERT INTO `testing` VALUES ('14', 'lriley@labsource.com', 'lriley', 'labsource.com');
INSERT INTO `testing` VALUES ('15', 'lix5010@yahoo.com', 'lix5010', 'yahoo.com');
INSERT INTO `testing` VALUES ('16', 'tmrl64@aol.com', 'tmrl64', 'aol.com');
INSERT INTO `testing` VALUES ('17', 'johnl@leonardpaper.com', 'johnl', 'leonardpaper.com');
INSERT INTO `testing` VALUES ('18', 'susanb@lspinc.com', 'susanb', 'lspinc.com');
INSERT INTO `testing` VALUES ('19', 'cwilson@lspinc.com', 'cwilson', 'lspinc.com');
INSERT INTO `testing` VALUES ('20', 'dforrest@lspinc.com', 'dforrest', 'lspinc.com');
INSERT INTO `testing` VALUES ('21', 'gicsgovt@invitrogen.com', 'gicsgovt', 'invitrogen.com');
INSERT INTO `testing` VALUES ('22', 'shawna.elwell@lonza.com', 'shawna.elwell', 'lonza.com');
INSERT INTO `testing` VALUES ('23', 'Leslie.Sprowl@Lonza.com', 'Leslie.Sprowl', 'Lonza.com');
INSERT INTO `testing` VALUES ('24', 'servicedesk@lonza.com', 'servicedesk', 'lonza.com');
INSERT INTO `testing` VALUES ('25', 'wendy.wilcox@lonza.com', 'wendy.wilcox', 'lonza.com');
INSERT INTO `testing` VALUES ('26', 'leena.paul@lonza.com', 'leena.paul', 'lonza.com');
INSERT INTO `testing` VALUES ('27', 'jlally@ksesci.com', 'jlally', 'ksesci.com');
INSERT INTO `testing` VALUES ('28', 'sbatten@ksesci.com', 'sbatten', 'ksesci.com');
INSERT INTO `testing` VALUES ('29', 'Bone1946@aol.com', 'Bone1946', 'aol.com');
INSERT INTO `testing` VALUES ('30', 'susangitel@aol.com', 'susangitel', 'aol.com');
INSERT INTO `testing` VALUES ('31', 'orders@mantech-inc.com', 'orders', 'mantech-inc.com');
INSERT INTO `testing` VALUES ('32', 'dawn.wojcik@thermofisher.com', 'dawn.wojcik', 'thermofisher.com');
INSERT INTO `testing` VALUES ('33', 'scimedsales@themccgroup.com', 'scimedsales', 'themccgroup.com');
INSERT INTO `testing` VALUES ('34', 'rbilly@themccgroup.com', 'rbilly', 'themccgroup.com');
INSERT INTO `testing` VALUES ('35', 'GriggsK@corning.com', 'GriggsK', 'corning.com');
INSERT INTO `testing` VALUES ('36', 'medconeagle@erols.com', 'medconeagle', 'erols.com');
INSERT INTO `testing` VALUES ('37', 'mcobb@medicalplace.net', 'mcobb', 'medicalplace.net');
INSERT INTO `testing` VALUES ('38', 'customerservice@mgscientific.com', 'customerservice', 'mgscientific.com');
INSERT INTO `testing` VALUES ('39', 'rbecraft@mgscientific.com', 'rbecraft', 'mgscientific.com');
INSERT INTO `testing` VALUES ('40', 'RMcGregor@mgscientific.com', 'RMcGregor', 'mgscientific.com');
INSERT INTO `testing` VALUES ('41', 'nathan.bushue@midsci.com', 'nathan.bushue', 'midsci.com');
INSERT INTO `testing` VALUES ('42', 'orders@millipore.com', 'orders', 'millipore.com');
INSERT INTO `testing` VALUES ('43', 'MDennis@mobio.com', 'MDennis', 'mobio.com');
INSERT INTO `testing` VALUES ('44', 'claghabekian@mpbio.com', 'claghabekian', 'mpbio.com');
INSERT INTO `testing` VALUES ('45', 'info@nationaldiagnostics.com', 'info', 'nationaldiagnostics.com');
INSERT INTO `testing` VALUES ('46', 'Freezers@neb.com', 'Freezers', 'neb.com');
INSERT INTO `testing` VALUES ('47', 'levanos@neb.com', 'levanos', 'neb.com');
INSERT INTO `testing` VALUES ('49', 'richardm@nep-co.com', 'richardm', 'nep-co.com');
INSERT INTO `testing` VALUES ('50', 'anna@chemical.net', 'anna', 'chemical.net');
INSERT INTO `testing` VALUES ('51', 'heather@chemical.net', 'heather', 'chemical.net');
INSERT INTO `testing` VALUES ('52', 'michellez@chemical.net', 'michellez', 'chemical.net');
INSERT INTO `testing` VALUES ('53', 'veLindaParker@officedepot.com', 'veLindaParker', 'officedepot.com');
INSERT INTO `testing` VALUES ('54', 'info@openbiosystems.com', 'info', 'openbiosystems.com');
INSERT INTO `testing` VALUES ('55', 'mabner@frankparsons.com', 'mabner', 'frankparsons.com');
INSERT INTO `testing` VALUES ('56', 'sparent@pblbio.com', 'sparent', 'pblbio.com');
INSERT INTO `testing` VALUES ('57', 'kthompson@peprotech.com', 'kthompson', 'peprotech.com');
INSERT INTO `testing` VALUES ('58', 'las.sales@perkinelmer.com', 'las.sales', 'perkinelmer.com');
INSERT INTO `testing` VALUES ('60', 'dclark@phenxiresearch.com', 'dclark', 'phenxiresearch.com');
INSERT INTO `testing` VALUES ('61', 'gadams@phenixresearch.com', 'gadams', 'phenixresearch.com');
INSERT INTO `testing` VALUES ('62', 'jroegner@phenixresearch.com', 'jroegner', 'phenixresearch.com');
INSERT INTO `testing` VALUES ('63', 'rita.hammer@thermofisher.com', 'rita.hammer', 'thermofisher.com');
INSERT INTO `testing` VALUES ('64', 'tkeith@plan-sys.com', 'tkeith', 'plan-sys.com');
INSERT INTO `testing` VALUES ('65', 'jdepinto@polysciences.com', 'jdepinto', 'polysciences.com');
INSERT INTO `testing` VALUES ('66', 'steven@precisionplastics.com', 'steven', 'precisionplastics.com');
INSERT INTO `testing` VALUES ('67', 'info@prinsep.com', 'info', 'prinsep.com');
INSERT INTO `testing` VALUES ('69', 'custserv@promega.com', 'custserv', 'promega.com');
INSERT INTO `testing` VALUES ('70', 'Maria.Nolasco@qiagen.com', 'Maria.Nolasco', 'qiagen.com');
INSERT INTO `testing` VALUES ('71', 'shannon.cunningham@qiagen.com', 'shannon.cunningham', 'qiagen.com');
INSERT INTO `testing` VALUES ('72', 'Inna.Dzekunova@qiagen.com', 'Inna.Dzekunova', 'qiagen.com');
INSERT INTO `testing` VALUES ('73', 'Melissa.Reuter@qiagen.com', 'Melissa.Reuter', 'qiagen.com');
INSERT INTO `testing` VALUES ('74', 'CustomerService@qualitybiological.com', 'CustomerService', 'qualitybiological.com');
INSERT INTO `testing` VALUES ('75', 'grahama@qualitybiological.com', 'grahama', 'qualitybiological.com');
INSERT INTO `testing` VALUES ('76', 'dorseyj@qualitybiological.com', 'dorseyj', 'qualitybiological.com');
INSERT INTO `testing` VALUES ('77', 'dorseyj@qualitybiological.com', 'dorseyj', 'qualitybiological.com');
INSERT INTO `testing` VALUES ('78', 'LabFinder@aol.com', 'LabFinder', 'aol.com');
INSERT INTO `testing` VALUES ('79', 'qualitylabproducts@earthlink.net', 'qualitylabproducts', 'earthlink.net');
INSERT INTO `testing` VALUES ('80', 'john.keith@rainin.com', 'john.keith', 'rainin.com');
INSERT INTO `testing` VALUES ('81', 'pipets@rainin.com', 'pipets', 'rainin.com');
INSERT INTO `testing` VALUES ('82', 'chris.brick@rainin.com', 'chris.brick', 'rainin.com');
INSERT INTO `testing` VALUES ('83', 'Yohannes.Adall@rainin.com', 'Yohannes.Adall', 'rainin.com');
INSERT INTO `testing` VALUES ('84', 'michael.paler@rainin.com', 'michael.paler', 'rainin.com');
INSERT INTO `testing` VALUES ('85', 'tracy@hensonsales.com', 'tracy', 'hensonsales.com');
INSERT INTO `testing` VALUES ('86', 'info@rpmsc.com', 'info', 'rpmsc.com');
INSERT INTO `testing` VALUES ('87', 'service@rpicorp.com', 'service', 'rpicorp.com');
INSERT INTO `testing` VALUES ('88', 'dharrison@robertsoxygen.com', 'dharrison', 'robertsoxygen.com');
INSERT INTO `testing` VALUES ('89', 'rnewby@robertsoxygen.com', 'rnewby', 'robertsoxygen.com');
INSERT INTO `testing` VALUES ('90', 'info@roboz.com', 'info', 'roboz.com');
INSERT INTO `testing` VALUES ('91', 'indianapolis.bmbcustomerservice@roche.com', 'indianapolis.bmbcustomerservice', 'roche.com');
INSERT INTO `testing` VALUES ('92', 'diane.filo@roche.com', 'diane.filo', 'roche.com');
INSERT INTO `testing` VALUES ('93', 'mike.wade@roche.com', 'mike.wade', 'roche.com');
INSERT INTO `testing` VALUES ('94', 'deborahwalters.roche@comcast.net', 'deborahwalters.roche', 'comcast.net');
INSERT INTO `testing` VALUES ('95', 'richard.penney@roche.com', 'richard.penney', 'roche.com');
INSERT INTO `testing` VALUES ('96', 'lorisillito@saftpak.com', 'lorisillito', 'saftpak.com');
INSERT INTO `testing` VALUES ('97', 'sarstedt@bellsouth.net', 'sarstedt', 'bellsouth.net');
INSERT INTO `testing` VALUES ('98', 'sales@sarstedt.us', 'sales', 'sarstedt.us');
INSERT INTO `testing` VALUES ('99', 'sales@sarstedt.us', 'sales', 'sarstedt.us');
INSERT INTO `testing` VALUES ('100', 'RayLSRi@aol.com', 'RayLSRi', 'aol.com');
INSERT INTO `testing` VALUES ('101', 'aptjcassidy@juno.com', 'aptjcassidy', 'juno.com');
INSERT INTO `testing` VALUES ('102', 'calendar@scullstudios.com', 'calendar', 'scullstudios.com');
INSERT INTO `testing` VALUES ('103', 'patty_barnett@schleicher-schuell.com', 'patty_barnett', 'schleicher-schuell.com');
INSERT INTO `testing` VALUES ('104', 'ymaguire@shamrockLabels.com', 'ymaguire', 'shamrockLabels.com');
INSERT INTO `testing` VALUES ('105', 'MIDAsupport@sial.com', 'MIDAsupport', 'sial.com');
INSERT INTO `testing` VALUES ('106', 'cupomt@verizon.net', 'cupomt', 'verizon.net');
INSERT INTO `testing` VALUES ('107', 'cupomt@verizon.net', 'cupomt', 'verizon.net');
INSERT INTO `testing` VALUES ('108', 'JGross@sobran-inc.com', 'JGross', 'sobran-inc.com');
INSERT INTO `testing` VALUES ('109', 'MRaoul@sobran-inc.com', 'MRaoul', 'sobran-inc.com');
INSERT INTO `testing` VALUES ('110', 'Meidl@sobran-inc.com', 'Meidl', 'sobran-inc.com');
INSERT INTO `testing` VALUES ('111', 'mkohlberger@spectrumchemical.com', 'mkohlberger', 'spectrumchemical.com');
INSERT INTO `testing` VALUES ('112', 'sudhakar_velaga@sra.com', 'sudhakar_velaga', 'sra.com');
INSERT INTO `testing` VALUES ('113', 'tyrone.shoulders@staples.com', 'tyrone.shoulders', 'staples.com');
INSERT INTO `testing` VALUES ('114', 'neal@arbenbio.com', 'neal', 'arbenbio.com');
INSERT INTO `testing` VALUES ('115', 'orders@teknova.com', 'orders', 'teknova.com');
INSERT INTO `testing` VALUES ('116', 'aaron.baxter@thermofisher.com', 'aaron.baxter', 'thermofisher.com');
INSERT INTO `testing` VALUES ('117', 'brad.galbreath@thermofisher.com', 'brad.galbreath', 'thermofisher.com');
INSERT INTO `testing` VALUES ('118', 'dayne.trussell@thermofisher.com', 'dayne.trussell', 'thermofisher.com');
INSERT INTO `testing` VALUES ('119', 'jesse.nicholson@thermofisher.com', 'jesse.nicholson', 'thermofisher.com');
INSERT INTO `testing` VALUES ('120', 'lauren.pantzar@thermofisher.com', 'lauren.pantzar', 'thermofisher.com');
INSERT INTO `testing` VALUES ('121', 'rich.oprison@thermofisher.com', 'rich.oprison', 'thermofisher.com');
INSERT INTO `testing` VALUES ('122', 'ryan.vinton@thermofisher.com', 'ryan.vinton', 'thermofisher.com');
INSERT INTO `testing` VALUES ('123', 'stan.nelson@thermofisher.com', 'stan.nelson', 'thermofisher.com');
INSERT INTO `testing` VALUES ('124', 'laura.winslow@thermofisher.com', 'laura.winslow', 'thermofisher.com');
INSERT INTO `testing` VALUES ('125', 'dwayne.trussell@thermofisher.com', 'dwayne.trussell', 'thermofisher.com');
INSERT INTO `testing` VALUES ('126', 'josiep@thomassci.com', 'josiep', 'thomassci.com');
INSERT INTO `testing` VALUES ('127', 'charlesl@thomassci.com', 'charlesl', 'thomassci.com');
INSERT INTO `testing` VALUES ('128', 'charles@thomassci.com', 'charles', 'thomassci.com');
INSERT INTO `testing` VALUES ('129', 'melissak@thomassci.com', 'melissak', 'thomassci.com');
INSERT INTO `testing` VALUES ('130', 'MagdaB@thomassci.com', 'MagdaB', 'thomassci.com');
INSERT INTO `testing` VALUES ('131', 'todd@totalmrollc.com', 'todd', 'totalmrollc.com');
INSERT INTO `testing` VALUES ('132', 'info@trevigen.com', 'info', 'trevigen.com');
INSERT INTO `testing` VALUES ('133', 'lburnett@frankparsons.com', 'lburnett', 'frankparsons.com');
INSERT INTO `testing` VALUES ('134', 'ymeseretu@usosop.com', 'ymeseretu', 'usosop.com');
INSERT INTO `testing` VALUES ('135', 'curtisf@usosop.com', 'curtisf', 'usosop.com');
INSERT INTO `testing` VALUES ('136', 'jcastle@usascientific.com', 'jcastle', 'usascientific.com');
INSERT INTO `testing` VALUES ('137', 'jcastle@usascientific.com', 'jcastle', 'usascientific.com');
INSERT INTO `testing` VALUES ('138', 'vetmeds@gmx.com', 'vetmeds', 'gmx.com');
INSERT INTO `testing` VALUES ('139', 'contact@viaflo.com', 'contact', 'viaflo.com');
INSERT INTO `testing` VALUES ('140', 'kdemanche@viaflo.com', 'kdemanche', 'viaflo.com');
INSERT INTO `testing` VALUES ('141', 'Karen.hasson@vitascientific.com', 'Karen.hasson', 'vitascientific.com');
INSERT INTO `testing` VALUES ('142', 'jche@mydbio.com', 'jche', 'mydbio.com');
INSERT INTO `testing` VALUES ('143', 'government_customerservice@vwr.com', 'government_customerservice', 'vwr.com');
INSERT INTO `testing` VALUES ('144', 'charles_daniels@vwr.com', 'charles_daniels', 'vwr.com');
INSERT INTO `testing` VALUES ('145', 'michael_lesch@vwr.com', 'michael_lesch', 'vwr.com');
INSERT INTO `testing` VALUES ('146', 'bob_wilgus@vwr.com', 'bob_wilgus', 'vwr.com');
INSERT INTO `testing` VALUES ('147', 'Timothy_Smith@vwr.com', 'Timothy_Smith', 'vwr.com');
INSERT INTO `testing` VALUES ('148', 'sales@westnetmed.com', 'sales', 'westnetmed.com');
INSERT INTO `testing` VALUES ('149', 'syamamoto@watsonbiolab.com', 'syamamoto', 'watsonbiolab.com');
INSERT INTO `testing` VALUES ('150', 'sales@westnetmed.com', 'sales', 'westnetmed.com');
INSERT INTO `testing` VALUES ('151', 'gordon@westnetmed.com', 'gordon', 'westnetmed.com');
INSERT INTO `testing` VALUES ('152', 'khoefling@westnetmed.com', 'khoefling', 'westnetmed.com');
INSERT INTO `testing` VALUES ('153', 'lbanner@westnetmed.com', 'lbanner', 'westnetmed.com');
INSERT INTO `testing` VALUES ('154', 'paul.margitich@whatman.com', 'paul.margitich', 'whatman.com');
INSERT INTO `testing` VALUES ('155', 'sales@willardpackaging.com', 'sales', 'willardpackaging.com');
INSERT INTO `testing` VALUES ('156', 'dspaventa@wwmponline.com', 'dspaventa', 'wwmponline.com');
INSERT INTO `testing` VALUES ('157', 'zhangl@zbiomed.com', 'zhangl', 'zbiomed.com');
INSERT INTO `testing` VALUES ('158', 'Lwyatt@zeiglerfeed.com', 'Lwyatt', 'zeiglerfeed.com');
INSERT INTO `testing` VALUES ('159', 'jorge.valdesmarcano.civ@mail.mil', 'jorge.valdesmarcano.civ', 'mail.mil');
INSERT INTO `testing` VALUES ('160', 'ranoia@wwmponline.com', 'ranoia', 'wwmponline.com');
INSERT INTO `testing` VALUES ('161', 'elmeco@comcast.net', 'elmeco', 'comcast.net');
INSERT INTO `testing` VALUES ('162', 'lix5010@yahoo.com', 'lix5010', 'yahoo.com');
INSERT INTO `testing` VALUES ('163', 'Linda@TheLabresource.com', 'Linda', 'TheLabresource.com');

-- ----------------------------
-- Table structure for `tls_policies`
-- ----------------------------
DROP TABLE IF EXISTS `tls_policies`;
CREATE TABLE `tls_policies` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(255) DEFAULT NULL,
  `method` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  `action` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=33 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of tls_policies
-- ----------------------------

-- ----------------------------
-- Table structure for `transport`
-- ----------------------------
DROP TABLE IF EXISTS `transport`;
CREATE TABLE `transport` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(255) DEFAULT NULL,
  `transport` varchar(255) DEFAULT NULL,
  `destination` varchar(255) DEFAULT NULL,
  `method` varchar(255) DEFAULT NULL,
  `port` float DEFAULT NULL,
  `mx` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=367 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of transport
-- ----------------------------
INSERT INTO `transport` VALUES ('366', 'domain.tld', 'smtp:[192.168.0.100]:25', '192.168.0.100', 'smtp', '25', 'NO');

-- ----------------------------
-- Table structure for `transport_temp`
-- ----------------------------
DROP TABLE IF EXISTS `transport_temp`;
CREATE TABLE `transport_temp` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `domain` varchar(255) DEFAULT NULL,
  `transport` varchar(255) DEFAULT NULL,
  `destination` varchar(255) DEFAULT NULL,
  `method` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=159 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of transport_temp
-- ----------------------------

-- ----------------------------
-- Table structure for `user_destinations`
-- ----------------------------
DROP TABLE IF EXISTS `user_destinations`;
CREATE TABLE `user_destinations` (
  `id` int(11) DEFAULT NULL,
  `destination` varchar(255) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of user_destinations
-- ----------------------------
INSERT INTO `user_destinations` VALUES ('1', 'index.cfm');
INSERT INTO `user_destinations` VALUES ('2', 'loading.cfm');
INSERT INTO `user_destinations` VALUES ('3', 'user_reports.cfm');
INSERT INTO `user_destinations` VALUES ('4', 'user_filters.cfm');
INSERT INTO `user_destinations` VALUES ('5', 'user_policy.cfm');
INSERT INTO `user_destinations` VALUES ('6', 'user_virtual.cfm');
INSERT INTO `user_destinations` VALUES ('7', 'loading2.cfm');
INSERT INTO `user_destinations` VALUES ('8', 'user_release_message.cfm');

-- ----------------------------
-- Table structure for `user_settings`
-- ----------------------------
DROP TABLE IF EXISTS `user_settings`;
CREATE TABLE `user_settings` (
  `id` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `datetime` datetime DEFAULT NULL,
  `report_frequency` int(11) DEFAULT NULL,
  `report_enabled` varchar(255) DEFAULT NULL,
  `password_set` int(11) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `train_bayes` int(11) DEFAULT NULL,
  `download_msg` int(11) DEFAULT NULL,
  `reset_password_code` varchar(255) DEFAULT NULL,
  `reset_password_ip` varchar(255) DEFAULT NULL,
  `reset_password_datetime` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of user_settings
-- ----------------------------

-- ----------------------------
-- Table structure for `users`
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `policy_id` int(11) DEFAULT NULL,
  `email` varbinary(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `pdf_enabled` int(11) DEFAULT NULL,
  `smime_enabled` int(11) DEFAULT NULL,
  `pgp_enabled` int(11) DEFAULT NULL,
  `smime_mode` int(11) DEFAULT NULL,
  `external_ca` int(11) DEFAULT NULL,
  `smime_certificate_key` varchar(255) DEFAULT NULL,
  `smime_certificate_request` varchar(255) DEFAULT NULL,
  `smime_certificate_name` varchar(255) DEFAULT NULL,
  `digital_sign` int(11) DEFAULT NULL,
  `pfx_certificate_name` varchar(255) DEFAULT NULL,
  `smime_certificate_password` varchar(255) DEFAULT NULL,
  `smime_certificate_expiration` date DEFAULT NULL,
  `validity` varchar(255) DEFAULT NULL,
  `encryption` varchar(255) DEFAULT NULL,
  `algorithm` varchar(255) DEFAULT NULL,
  `ca_id` int(11) DEFAULT NULL,
  `configured` int(11) DEFAULT NULL,
  `domain` int(11) DEFAULT NULL,
  `priority` int(11) NOT NULL DEFAULT '7',
  `uniqueid` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=1481 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1480', null, 0x40646F6D61696E2E746C64, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, null, '1', '7', null);

-- ----------------------------
-- Table structure for `virtual_recipients`
-- ----------------------------
DROP TABLE IF EXISTS `virtual_recipients`;
CREATE TABLE `virtual_recipients` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `virtual_address` varchar(255) NOT NULL,
  `maps` varchar(255) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=285 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of virtual_recipients
-- ----------------------------
INSERT INTO `virtual_recipients` VALUES ('282', 'postmaster@domain.tld', 'someone@otherdomain.tld', '1');
INSERT INTO `virtual_recipients` VALUES ('283', 'root@domain.tld', 'someone@otherdomain.tld', '1');
INSERT INTO `virtual_recipients` VALUES ('284', 'abuse@domain.tld', 'someone@otherdomain.tld', '1');

-- ----------------------------
-- Table structure for `wblist`
-- ----------------------------
DROP TABLE IF EXISTS `wblist`;
CREATE TABLE `wblist` (
  `rid` int(10) unsigned NOT NULL,
  `sid` int(10) unsigned NOT NULL,
  `wb` varchar(10) NOT NULL,
  PRIMARY KEY (`rid`,`sid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of wblist
-- ----------------------------

-- ----------------------------
-- View structure for `file_types2`
-- ----------------------------
DROP VIEW IF EXISTS `file_types2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `file_types2` AS select distinct `files`.`type` AS `type` from `files` order by `files`.`type` ;

-- ----------------------------
-- View structure for `recipients2`
-- ----------------------------
DROP VIEW IF EXISTS `recipients2`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`%` SQL SECURITY DEFINER VIEW `recipients2` AS select `users`.`id` AS `id`,`users`.`policy_id` AS `policy_id`,`users`.`email` AS `recipient`,`users`.`status` AS `status`,`users`.`pdf_enabled` AS `pdf_enabled`,`users`.`smime_enabled` AS `smime_enabled`,`users`.`smime_mode` AS `smime_mode`,`users`.`external_ca` AS `external_ca`,`users`.`smime_certificate_key` AS `smime_certificate_key`,`users`.`smime_certificate_request` AS `smime_certificate_request`,`users`.`smime_certificate_name` AS `smime_certificate_name`,`users`.`digital_sign` AS `digital_sign`,`users`.`pfx_certificate_name` AS `pfx_certificate_name`,`users`.`smime_certificate_password` AS `smime_certificate_password`,`users`.`smime_certificate_expiration` AS `smime_certificate_expiration`,`users`.`validity` AS `validity`,`users`.`encryption` AS `encryption`,`users`.`algorithm` AS `algorithm`,`users`.`ca_id` AS `ca_id`,`users`.`configured` AS `configured`,`users`.`domain` AS `domain` from `users` ;
