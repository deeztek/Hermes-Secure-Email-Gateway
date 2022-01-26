/*
BUILD HERMES DATABASE
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
INSERT INTO `aliases` VALUES ('1', 'postmaster', 'somone@domain.tld');
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
-- Table structure for `crontab_entries`
-- ----------------------------
DROP TABLE IF EXISTS `crontab_entries`;
CREATE TABLE `crontab_entries` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `value` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of crontab_entries
-- ----------------------------
INSERT INTO `crontab_entries` VALUES ('1', '15 */1 * * *', 'Every 1 Hours');
INSERT INTO `crontab_entries` VALUES ('2', '15 */2 * * *', 'Every 2 Hours');
INSERT INTO `crontab_entries` VALUES ('3', '15 */4 * * *', 'Every 4 Hours');
INSERT INTO `crontab_entries` VALUES ('4', '15 */8 * * *', 'Every 8 Hours');
INSERT INTO `crontab_entries` VALUES ('5', '15 */12 * * *', 'Every 12 Hours');
INSERT INTO `crontab_entries` VALUES ('6', '30 0 * * *', 'Every 24 Hours');

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
INSERT INTO `encryption_settings` VALUES ('617', 'portal_url', 'user.portal.baseURL', 'https://hermes.domain.tld/web/portal');
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
  `note` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `hermesadmin` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ciphermailadmin` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `datetime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=99 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=96 DEFAULT CHARSET=latin1;

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
INSERT INTO `malware_databases` VALUES ('95', 'urlhaus.ndb', 'URLHAUS DATABASE - Malicious URLs that are being used for malware distribution', 'true', 'urlhaus', 'low', '2');

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
  `securite_premium` varchar(255) DEFAULT NULL,
  `template` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of malware_feeds
-- ----------------------------
INSERT INTO `malware_feeds` VALUES ('1', 'sanesecurity', 'yes', null, null, null, null, '2', null, null, null);
INSERT INTO `malware_feeds` VALUES ('2', 'securiteinfo', 'yes', '4', 'e7fe28d465808e0ce4278955d8e0a5bed43f76bae9d6bb24a6f6b9b685696e10b92af719c7adc07aa1ac2cc0dafa6638a0cc0d37688904075c8446781be5bb5f', null, null, '2', null, 'no', null);
INSERT INTO `malware_feeds` VALUES ('3', 'linuxmalwaredetect', 'yes', '8', null, null, null, '2', null, null, null);
INSERT INTO `malware_feeds` VALUES ('4', 'yararules', 'yes', '1', null, null, null, '2', null, null, null);
INSERT INTO `malware_feeds` VALUES ('5', 'malwarepatrol', 'yes', '2', '106261422496', '15', 'clamav_ext', '2', 'no', null, null);
INSERT INTO `malware_feeds` VALUES ('6', 'urlhaus', 'yes', '0', null, null, null, '2', null, null, null);

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
INSERT INTO `parameters` VALUES ('25', 'domain.tld', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `parameters` VALUES ('26', 'hermes', null, null, null, null, null, 'postfix', null, null, '1', 'main.cf', null, '2', '1', '1', '1', '1', null, null, null);
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
INSERT INTO `parameters2` VALUES ('22', 'network_mode', 'dhcp', 'network', '1', '1');
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
INSERT INTO `parameters2` VALUES ('88', 'jwt_secret', '', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('89', 'access_control.rules.policy', '', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('90', 'authentication_backend.disable_reset_password', 'false', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('91', 'session.name', 'hermes_session', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('92', 'session.secret', '', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('93', 'session.expiration', '3600', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('94', 'session.inactivity', '3600', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('95', 'session.domain', null, 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('96', 'notifier.smtp.host', '[127.0.0.1]', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('97', 'notifier.smtp.port', '10026', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('98', 'notifier.smtp.sender', 'no-reply@domain.tld', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('99', 'notifier.smtp.subject', '[Hermes SEG] {title}', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('100', 'regulation.max_retries', '5', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('101', 'regulation.find_time', '120', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('102', 'regulation.ban_time', '300', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('103', 'log.level', 'debug', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('104', 'log.format', 'text', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('105', 'access_control.domain', 'domain.tld', 'authelia', '1', '1');
INSERT INTO `parameters2` VALUES ('106', 'console.certificate', '1', 'console', '1', '2');
INSERT INTO `parameters2` VALUES ('107', 'smtp.certificate', '1', 'certificates', '1', '1');
INSERT INTO `parameters2` VALUES ('109', 'console.host', 'host.domain.tld', 'console', '1', '2');
INSERT INTO `parameters2` VALUES ('108', 'console.mode', 'ip', 'console', '1', '2');
INSERT INTO `parameters2` VALUES ('133', 'console.dhparam', 'disable', 'console', '1', '2');
INSERT INTO `parameters2` VALUES ('134', 'console.hsts', 'disable', 'console', '1', '2');
INSERT INTO `parameters2` VALUES ('135', 'console.ssl_stapling', 'disable', 'console', '1', '2');
INSERT INTO `parameters2` VALUES ('136', 'console.ssl_stapling_verify', 'disable', 'console', '1', '2');

-- ----------------------------
-- Table structure for `system_certificates`
-- ----------------------------
DROP TABLE IF EXISTS `system_certificates`;
CREATE TABLE `system_certificates` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` varchar(255) DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `issuer` varchar(255) DEFAULT NULL,
  `serial` varchar(255) DEFAULT NULL,
  `fingerprint` varchar(255) DEFAULT NULL,
  `startdate` varchar(255) DEFAULT NULL,
  `enddate` varchar(255) DEFAULT NULL,
  `file_name` varchar(255) DEFAULT NULL,
  `friendly_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of system_certificates
-- ----------------------------
INSERT INTO `system_certificates` VALUES ('1', 'Imported', '=== DO NOT DELETE ===', '=== DO NOT DELETE ===', '=== DO NOT DELETE ===', '=== DO NOT DELETE ===', null, null, 'ssl-cert-snakeoil', 'system-self-signed');



-- ----------------------------
-- Table structure for `api_tokens`
-- ----------------------------
DROP TABLE IF EXISTS `api_tokens`;
CREATE TABLE `api_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `token` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  `active` int(11) DEFAULT NULL,
  `verify` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of api_tokens
-- ----------------------------
INSERT INTO `api_tokens` VALUES ('1', '', 'Built-In System', '127.0.0.1', '1', '1', '');


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
) ENGINE=MyISAM AUTO_INCREMENT=14832 DEFAULT CHARSET=latin1;

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
INSERT INTO `spam_settings` VALUES ('1', 'user_portal', 'https://hermes.domain.tld/users', null, null, null, null, null, null, '1', '1');
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
INSERT INTO `spam_settings` VALUES ('1462', 'bayes_auto_learn_threshold_nonspam', '-5', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('1463', 'bayes_auto_learn_threshold_spam', '15', null, null, null, null, null, null, '1', '1');
INSERT INTO `spam_settings` VALUES ('1444', 'previous_use_bayes', '1', null, null, null, null, null, null, null, null);


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
INSERT INTO `system_settings` VALUES ('72', 'build_no', '211207');
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
) ENGINE=InnoDB AUTO_INCREMENT=39 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of system_updates
-- ----------------------------
INSERT INTO `system_updates` VALUES ('29', '16.04', '180831', '1', '2018-08-31 00:00:00', '1');
INSERT INTO `system_updates` VALUES ('34', '16.04', '181221', '1', '2018-12-21 11:49:04', '2');
INSERT INTO `system_updates` VALUES ('35', '16.04', '190405', '1', '2019-04-07 05:33:23', '3');
INSERT INTO `system_updates` VALUES ('36', '16.04', '190415', '1', '2019-05-07 10:03:39', '4');
INSERT INTO `system_updates` VALUES ('37', '18.04', '191205', '1', '2019-12-05 00:00:00', '5');
INSERT INTO `system_updates` VALUES ('38', '18.04', '200125', '1', '2020-01-25 00:00:00', '6');
INSERT INTO `system_updates` VALUES ('39', '18.04', '200829', '1', '2020-08-29 00:00:00', '8');
INSERT INTO `system_updates` VALUES ('40', '18.04', '200830', '1', '2020-08-30 00:00:00', '9');
INSERT INTO `system_updates` VALUES ('41', '18.04', '210113', '1', '2021-01-13 00:00:00', '10');
INSERT INTO `system_updates` VALUES ('42', '18.04', '210501', '1', '2021-05-01 00:00:00', '11');
INSERT INTO `system_updates` VALUES ('43', '18.04', '211009', '1', '2021-10-09 00:00:00', '12');
INSERT INTO `system_updates` VALUES ('44', '18.04', '211019', '1', '2021-11-15 00:00:00', '13');
INSERT INTO `system_updates` VALUES ('45', '18.04', '211207', '1', '2022-01-14 00:00:00', '14');

-- ----------------------------
-- Table structure for `system_users`
-- ----------------------------
DROP TABLE IF EXISTS `system_users`;
CREATE TABLE `system_users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `first_name` varchar(255) DEFAULT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `system` int(11) DEFAULT NULL,
  `access_control` varchar(255) DEFAULT NULL,
  `applied` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=26 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of system_users
-- ----------------------------
INSERT INTO `system_users` VALUES ('1', 'admin', '$argon2id$v=19$m=65536,t=1,p=8$TEVla212MnJOeEV4RGNEWA$vJlaEm/liD9PRgGKEvoidKldw7xgcrhw0kDN+YH8Pck', 'someone@domain.tld', 'System', 'User', '1', 'one_factor', '1');

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
INSERT INTO `user_destinations` VALUES ('1', '2/index.cfm');
INSERT INTO `user_destinations` VALUES ('2', '2/preloader_view_message_history.cfm');
INSERT INTO `user_destinations` VALUES ('3', 'user_reports.cfm');
INSERT INTO `user_destinations` VALUES ('4', '2/view_sender_filters.cfm');
INSERT INTO `user_destinations` VALUES ('5', 'user_policy.cfm');
INSERT INTO `user_destinations` VALUES ('6', 'user_virtual.cfm');
INSERT INTO `user_destinations` VALUES ('7', '2/preloader_view_message.cfm');
INSERT INTO `user_destinations` VALUES ('8', '2/release_message.cfm');

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
) ENGINE=MyISAM AUTO_INCREMENT=288 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of virtual_recipients
-- ----------------------------
INSERT INTO `virtual_recipients` VALUES ('286', 'root@domain.tld', 'someone@otherdomain.tld', '1');
INSERT INTO `virtual_recipients` VALUES ('285', 'postmaster@domain.tld', 'someone@otherdomain.tld', '1');
INSERT INTO `virtual_recipients` VALUES ('287', 'abuse@domain.tld', 'someone@otherdomain.tld', '1');

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
