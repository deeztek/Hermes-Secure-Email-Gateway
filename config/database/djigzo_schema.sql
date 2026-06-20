
    create table cm_admin (
        cm_id bigint not null auto_increment,
        cm_built_in bit,
        cm_enabled bit,
        cm_password varchar(255),
        cm_password_encoding integer,
        cm_salt varchar(255),
        cm_username varchar(255) not null unique,
        primary key (cm_id)
    );

    create table cm_admin_cm_authorities (
        cm_admin bigint not null,
        cm_authorities bigint not null,
        primary key (cm_admin, cm_authorities)
    );

    create table cm_authority (
        cm_id bigint not null auto_increment,
        cm_role varchar(255) not null unique,
        primary key (cm_id)
    );

    create table cm_blob (
        cm_id bigint not null auto_increment,
        cm_blob LONGBLOB,
        primary key (cm_id)
    );

    create table cm_certificate_request (
        cm_id bigint not null auto_increment,
        cm_certificate_handler_name varchar(255),
        cm_created datetime not null,
        cm_crl_dist_point text,
        cm_data LONGBLOB,
        cm_email text,
        cm_info text,
        cm_iteration integer,
        cm_key_length integer,
        cm_last_message text,
        cm_last_updated datetime,
        cm_next_update datetime,
        cm_private_key LONGBLOB,
        cm_public_key LONGBLOB,
        cm_signature_algorithm varchar(255),
        cm_subject LONGBLOB,
        cm_validity integer,
        primary key (cm_id)
    );

    create table cm_certificates (
        cm_id bigint not null auto_increment,
        cm_not_before datetime,
        cm_not_after datetime,
        cm_issuer text,
        cm_issuer_friendly text,
        cm_serial text,
        cm_subject_key_identifier text,
        cm_subject text,
        cm_subject_friendly text,
        cm_certificate LONGBLOB,
        cm_thumbprint varchar(255),
        cm_cert_path LONGBLOB,
        cm_cert_path_type varchar(255),
        cm_creation_date datetime,
        cm_date_path_updated datetime,
        cm_key_alias text,
        cm_store_name varchar(255),
        primary key (cm_id),
        unique (cm_store_name, cm_thumbprint)
    );

    create table cm_certificates_email (
        cm_certificates_id bigint not null,
        cm_email text,
        gl_id bigint not null auto_increment,
        primary key (gl_id)
    );

    create table cm_crls (
        cm_id bigint not null auto_increment,
        cm_creation_date datetime,
        cm_issuer text,
        cm_next_update datetime,
        cm_this_update datetime,
        cm_crl_number text,
        cm_crl LONGBLOB,
        cm_thumbprint varchar(255),
        cm_store_name varchar(255),
        primary key (cm_id),
        unique (cm_store_name, cm_thumbprint)
    );

    create table cm_ctl (
        cm_id bigint not null auto_increment,
        cm_name varchar(255),
        cm_thumbprint varchar(255) not null,
        primary key (cm_id),
        unique (cm_name, cm_thumbprint)
    );

    create table cm_ctl_cm_name_values (
        cm_ctl bigint not null,
        cm_value text,
        cm_name varchar(255),
        primary key (cm_ctl, cm_name)
    );

    create table cm_keyring (
        cm_id bigint not null auto_increment,
        cm_content LONGBLOB,
        cm_content_type text,
        cm_creation_date datetime,
        cm_public_key LONGBLOB not null,
        cm_expiration_date datetime,
        cm_fingerprint text not null,
        cm_insertion_date datetime,
        cm_keyid bigint not null,
        cm_keyidhex varchar(255) not null,
        cm_key_ring_name varchar(255) not null,
        cm_master bit not null,
        cm_parent_keyid bigint,
        cm_private_key_alias text,
        cm_sha256fingerprint varchar(255) not null,
        cm_parentid bigint,
        primary key (cm_id),
        unique (cm_key_ring_name, cm_sha256fingerprint)
    );

    create table cm_keyring_email (
        cm_keyring_id bigint not null,
        cm_email text,
        gl_id bigint not null auto_increment,
        primary key (gl_id)
    );

    create table cm_keyring_userid (
        cm_keyring_id bigint not null,
        cm_userid text,
        gl_id bigint not null auto_increment,
        primary key (gl_id)
    );

    create table cm_keystore (
        cm_id bigint not null auto_increment,
        cm_alias varchar(255) not null,
        cm_certificate LONGBLOB,
        cm_certificate_type varchar(255),
        cm_thumbprint varchar(255),
        cm_certificate_chain LONGBLOB,
        cm_creation_date datetime,
        cm_encoded_key LONGBLOB,
        cm_store_name varchar(255) not null,
        primary key (cm_id),
        unique (cm_store_name, cm_alias)
    );

    create table cm_mail_repository (
        cm_id varchar(255) not null,
        cm_data LONGBLOB,
        cm_created datetime,
        cm_from_header text,
        cm_last_updated datetime,
        cm_messageid text,
        cm_originator text,
        cm_remote_address text,
        cm_repository varchar(255),
        cm_sender text,
        cm_subject text,
        cm_mime bigint,
        primary key (cm_id)
    );

    create table cm_mail_repository_recipients (
        cm_id varchar(255) not null,
        cm_recipients text,
        gl_id bigint not null auto_increment,
        primary key (gl_id)
    );

    create table cm_named_blob (
        cm_id bigint not null auto_increment,
        cm_category varchar(255) not null,
        cm_name varchar(255) not null,
        cm_blob_entity bigint,
        primary key (cm_id),
        unique (cm_category, cm_name)
    );

    create table cm_named_blob_cm_named_blobs (
        cm_named_blob bigint not null,
        cm_named_blobs bigint not null,
        primary key (cm_named_blob, cm_named_blobs)
    );

    create table cm_pgp_trust_list (
        cm_id bigint not null auto_increment,
        cm_fingerprint varchar(255) not null,
        cm_name varchar(255),
        primary key (cm_id),
        unique (cm_name, cm_fingerprint)
    );

    create table cm_pgp_trust_list_cm_name_values (
        cm_pgp_trust_list bigint not null,
        cm_value text,
        cm_name varchar(255),
        primary key (cm_pgp_trust_list, cm_name)
    );

    create table cm_properties (
        cm_id bigint not null auto_increment,
        cm_category varchar(255) unique,
        primary key (cm_id)
    );

    create table cm_properties_cm_name_values (
        cm_properties bigint not null,
        cm_value mediumtext,
        cm_name varchar(255),
        primary key (cm_properties, cm_name)
    );

    create table cm_sms (
        cm_id bigint not null auto_increment,
        cm_data LONGBLOB,
        cm_date_created datetime,
        cm_date_last_try datetime,
        cm_last_error text,
        cm_message text not null,
        cm_phone_number varchar(255) not null,
        primary key (cm_id)
    );

    create table cm_userpreferences (
        cm_id bigint not null auto_increment,
        cm_category varchar(255) not null,
        cm_name varchar(255) not null,
        cm_property_entity bigint,
        cm_key_and_certificate_entry bigint,
        primary key (cm_id),
        unique (cm_category, cm_name)
    );

    create table cm_userpreferences_cm_certificates (
        cm_userpreferences bigint not null,
        cm_certificates bigint not null,
        primary key (cm_userpreferences, cm_certificates)
    );

    create table cm_userpreferences_cm_named_blobs (
        cm_userpreferences bigint not null,
        cm_named_blobs bigint not null,
        primary key (cm_userpreferences, cm_named_blobs)
    );

    create table cm_userpreferences_inheritedpreferences (
        cm_userpreferences bigint not null,
        cm_index bigint not null,
        cm_inherited_preferences_id bigint not null,
        primary key (cm_userpreferences, cm_index, cm_inherited_preferences_id)
    );

    create table cm_userpreferences_named_certificates (
        cm_userpreferences bigint not null,
        cm_certificate_entry bigint,
        cm_name varchar(255),
        gl_id bigint not null auto_increment,
        primary key (gl_id)
    );

    create table cm_users (
        cm_id bigint not null auto_increment,
        cm_email varchar(255) not null unique,
        cm_user_preferences_entity bigint,
        primary key (cm_id)
    );

    alter table cm_admin_cm_authorities 
        add index FKB92F86713CAF3373 (cm_admin), 
        add constraint FKB92F86713CAF3373 
        foreign key (cm_admin) 
        references cm_admin (cm_id);

    alter table cm_admin_cm_authorities 
        add index FKB92F867123233879 (cm_authorities), 
        add constraint FKB92F867123233879 
        foreign key (cm_authorities) 
        references cm_authority (cm_id);

    create index certificateRequest_next_update_index on cm_certificate_request (cm_next_update);

    create index certificateRequest_created_index on cm_certificate_request (cm_created);

    create index certificates_creationdate_index on cm_certificates (cm_creation_date);

    alter table cm_certificates_email 
        add index FK618BE14E81712A2F (cm_certificates_id), 
        add constraint FK618BE14E81712A2F 
        foreign key (cm_certificates_id) 
        references cm_certificates (cm_id);

    alter table cm_ctl_cm_name_values 
        add index FKBD85E99A2BE6F657 (cm_ctl), 
        add constraint FKBD85E99A2BE6F657 
        foreign key (cm_ctl) 
        references cm_ctl (cm_id);

    alter table cm_keyring 
        add index FKF58C6A3A2B2B0656 (cm_parentid), 
        add constraint FKF58C6A3A2B2B0656 
        foreign key (cm_parentid) 
        references cm_keyring (cm_id);

    alter table cm_keyring_email 
        add index FK951D05577431C1C (cm_keyring_id), 
        add constraint FK951D05577431C1C 
        foreign key (cm_keyring_id) 
        references cm_keyring (cm_id);

    alter table cm_keyring_userid 
        add index FK2A27AFCB7431C1C (cm_keyring_id), 
        add constraint FK2A27AFCB7431C1C 
        foreign key (cm_keyring_id) 
        references cm_keyring (cm_id);

    alter table cm_mail_repository 
        add index FKB12990FDFF89F4D6 (cm_mime), 
        add constraint FKB12990FDFF89F4D6 
        foreign key (cm_mime) 
        references cm_blob (cm_id);

    alter table cm_mail_repository_recipients 
        add index FKDEF805FC716095DA (cm_id), 
        add constraint FKDEF805FC716095DA 
        foreign key (cm_id) 
        references cm_mail_repository (cm_id);

    alter table cm_named_blob 
        add index FKB36CEFD8FD03645D (cm_blob_entity), 
        add constraint FKB36CEFD8FD03645D 
        foreign key (cm_blob_entity) 
        references cm_blob (cm_id);

    alter table cm_named_blob_cm_named_blobs 
        add index FK1AE7DEE2615369E4 (cm_named_blob), 
        add constraint FK1AE7DEE2615369E4 
        foreign key (cm_named_blob) 
        references cm_named_blob (cm_id);

    alter table cm_named_blob_cm_named_blobs 
        add index FK1AE7DEE2681785A7 (cm_named_blobs), 
        add constraint FK1AE7DEE2681785A7 
        foreign key (cm_named_blobs) 
        references cm_named_blob (cm_id);

    alter table cm_pgp_trust_list_cm_name_values 
        add index FKB322F9E08CA8D07B (cm_pgp_trust_list), 
        add constraint FKB322F9E08CA8D07B 
        foreign key (cm_pgp_trust_list) 
        references cm_pgp_trust_list (cm_id);

    alter table cm_properties_cm_name_values 
        add index FK9425A1F8BDF917CD (cm_properties), 
        add constraint FK9425A1F8BDF917CD 
        foreign key (cm_properties) 
        references cm_properties (cm_id);

    create index sms_datelasttry_index on cm_sms (cm_date_last_try);

    alter table cm_userpreferences 
        add index FK9730847813954F5D (cm_property_entity), 
        add constraint FK9730847813954F5D 
        foreign key (cm_property_entity) 
        references cm_properties (cm_id);

    alter table cm_userpreferences 
        add index FK97308478E01BB373 (cm_key_and_certificate_entry), 
        add constraint FK97308478E01BB373 
        foreign key (cm_key_and_certificate_entry) 
        references cm_certificates (cm_id);

    alter table cm_userpreferences_cm_certificates 
        add index FKD7DB35AA9FB1915C (cm_userpreferences), 
        add constraint FKD7DB35AA9FB1915C 
        foreign key (cm_userpreferences) 
        references cm_userpreferences (cm_id);

    alter table cm_userpreferences_cm_certificates 
        add index FKD7DB35AA2BA6D0F7 (cm_certificates), 
        add constraint FKD7DB35AA2BA6D0F7 
        foreign key (cm_certificates) 
        references cm_certificates (cm_id);

    alter table cm_userpreferences_cm_named_blobs 
        add index FK283476429FB1915C (cm_userpreferences), 
        add constraint FK283476429FB1915C 
        foreign key (cm_userpreferences) 
        references cm_userpreferences (cm_id);

    alter table cm_userpreferences_cm_named_blobs 
        add index FK28347642681785A7 (cm_named_blobs), 
        add constraint FK28347642681785A7 
        foreign key (cm_named_blobs) 
        references cm_named_blob (cm_id);

    alter table cm_userpreferences_inheritedpreferences 
        add index FKBD7FB9459FB1915C (cm_userpreferences), 
        add constraint FKBD7FB9459FB1915C 
        foreign key (cm_userpreferences) 
        references cm_userpreferences (cm_id);

    alter table cm_userpreferences_inheritedpreferences 
        add index FKBD7FB945F2EBE2E0 (cm_inherited_preferences_id), 
        add constraint FKBD7FB945F2EBE2E0 
        foreign key (cm_inherited_preferences_id) 
        references cm_userpreferences (cm_id);

    alter table cm_userpreferences_named_certificates 
        add index FKEDF388299FB1915C (cm_userpreferences), 
        add constraint FKEDF388299FB1915C 
        foreign key (cm_userpreferences) 
        references cm_userpreferences (cm_id);

    alter table cm_userpreferences_named_certificates 
        add index FKEDF388297F50D4BB (cm_certificate_entry), 
        add constraint FKEDF388297F50D4BB 
        foreign key (cm_certificate_entry) 
        references cm_certificates (cm_id);

    alter table cm_users 
        add index FK5ADE85F35754340D (cm_user_preferences_entity), 
        add constraint FK5ADE85F35754340D 
        foreign key (cm_user_preferences_entity) 
        references cm_userpreferences (cm_id);
