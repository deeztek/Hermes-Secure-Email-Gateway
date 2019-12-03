CREATE TABLE `cm_certificates_tmp` (
`cm_id`  bigint(20) NOT NULL AUTO_INCREMENT ,
`cm_not_before`  datetime NULL DEFAULT NULL ,
`cm_not_after`  datetime NULL DEFAULT NULL ,
`cm_issuer`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
`cm_issuer_friendly`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
`cm_serial`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
`cm_subject_key_identifier`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
`cm_subject`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
`cm_subject_friendly`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
`cm_certificate`  longblob NULL ,
`cm_thumbprint`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`cm_cert_path`  longblob NULL ,
`cm_cert_path_type`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
`cm_creation_date`  datetime NULL DEFAULT NULL ,
`cm_date_path_updated`  datetime NULL DEFAULT NULL ,
`cm_key_alias`  text CHARACTER SET utf8 COLLATE utf8_general_ci NULL ,
`cm_store_name`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL ,
PRIMARY KEY (`cm_id`),
UNIQUE INDEX `cm_store_name` (`cm_store_name`, `cm_thumbprint`) USING BTREE ,
INDEX `certificates_creationdate_index` (`cm_creation_date`) USING BTREE 
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=utf8 COLLATE=utf8_general_ci
ROW_FORMAT=Dynamic
;

ALTER TABLE `cm_users` ADD COLUMN `cm_locality`  varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL AFTER `cm_user_preferences_entity`;