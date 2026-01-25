<h1 align="center"> Hermes Secure Email Gateway </h1> <br>
<p align="center">
  <a href="https://www.deeztek.com/products/hermes-secure-email-gateway/">
    <img alt="Hermes Secure Email Gateway" title="Hermes Secure Email Gateway" src="https://imgur.com/Qfzv1iZ.png" width="auto">
  </a>
</p>

<p align="center">
  Open Source Unified Secure Email Gateway - Docker Edition
</p>

## Table of Contents

- [About](#about)
- [Features](#features)
- [Architecture](#architecture)
- [Requirements](#requirements)
- [Installation](#installation)
- [Configuration](#configuration)
- [Documentation](#documentation)
- [Support](#support)
- [Bugs](#bugs)
- [License](#license)

## About

Hermes Secure Email Gateway is a Free Open Source Email Gateway that provides Spam, Virus and Malware protection, full in-transit and at-rest email encryption as well as email archiving. Hermes Secure Email Gateway combines Open Source technologies such as Postfix, Apache SpamAssassin, ClamAV, Amavisd-new and Ciphermail under one unified web based Web GUI for easy administration and management of your incoming and outgoing email for your organization. It can be deployed to protect your in-house email solution as well as cloud email solutions such as Google Mail and Microsoft Office 365.

This Docker edition provides a containerized deployment using Docker Compose for easier installation, management, and scalability.

## Features

* Malware and Spam Protection
* In Transit Email Encryption via Encrypted PDF, S/MIME, PGP and SMTP TLS
* Administrator Console (AdminLTE 4 / Bootstrap 5)
* User Console
* Built-In Email Archiving
* Active Directory Integration (PRO Feature)
* AD RemoteAuth - Pass-through authentication to Active Directory
* Searchable Event Logs
* Searchable Messages by Date/Time, Subject, Sender, Receiver, Type, Action
* Train Messages as Spam/Ham, Block/Allow Senders, Release to Recipient, Download Messages
* Integration with 3rd Party Threat Feeds such as Malware Patrol, Sanesecurity, Securite Info, Yara (PRO Feature)
* Built-In Firewall (PRO Feature)
* Multifactor Authentication via Authelia
* Lets Encrypt (ACME) Certificate Integration (PRO Feature)
* haveibeenpwned.com Password Check Integration
* Custom File Expressions (PRO Feature)
* Custom File Extensions (PRO Feature)
* Custom Spam Filter Tests (PRO Feature)
* Custom Messages Rules (PRO Feature)
* Antivirus Signature Bypass (PRO Feature)
* 3rd Party SSL Certificates
* SPF, DKIM Check, DKIM Sign, DMARC
* Per-User Spam, Virus and File Policies
* Real-time Dashboard with System Resource Monitoring
* Message Statistics with Visual Charts

## Architecture

Hermes SEG Docker Edition consists of the following containers:

| Container | Purpose | Ports |
|-----------|---------|-------|
| `hermes_commandbox` | CFML application server (Lucee) | 8888 |
| `hermes_postfix_dkim` | Mail transfer agent (Postfix + OpenDKIM) | 25, 587 |
| `hermes_mail_filter` | Content filtering (Amavis, SpamAssassin, ClamAV) | 10021, 10030 |
| `hermes_nginx` | Reverse proxy | 80, 443 |
| `hermes_authelia` | Authentication/SSO with MFA | 9091 |
| `hermes_ciphermail` | Email encryption | 8443 |
| `hermes_db_server` | MariaDB database | 3306 |
| `hermes_openldap` | LDAP directory | 1389 |

## Requirements

* Docker Engine 20.10+
* Docker Compose 2.0+
* Minimum 8 GB RAM
* Minimum 4 CPU cores
* Recommended: Separate volume/partition for `/mnt/data` (email archives, databases)

## Installation

### Clone the Repository

```bash
git clone https://gitlab.deeztek.com/dedwards/hermes-seg-docker-gl.git
cd hermes-seg-docker-gl
```

### Configure Environment

Copy the example environment file and configure your settings:

```bash
cp .env.example .env
```

Edit `.env` with your specific configuration:
- Database passwords
- Domain name
- SSL certificate paths
- LDAP settings

### Start the Containers

```bash
docker-compose up -d
```

### Verify Installation

Check that all containers are running:

```bash
docker-compose ps
```

### Access the Web Interface

- **Admin Console**: `https://your-domain/admin/2/`
- **User Console**: `https://your-domain/users/2/`

## Configuration

### Database Schema Updates

After initial installation or when upgrading, run the database schema updates:

```bash
docker exec -i hermes_db_server mysql -u root -p hermes < updates/hermes-260119/sql/schema_updates.sql
```

### SSL Certificates

Place your SSL certificates in the appropriate location or configure Let's Encrypt via the admin console.

### Active Directory Integration

For AD RemoteAuth (pass-through authentication):
1. Navigate to **System > AD RemoteAuth** in the admin console
2. Add domain mappings with your AD server details
3. Configure TLS settings and upload CA certificates if required
4. Sync configuration to LDAP

## Documentation

- [Hermes SEG Administrator Guide](https://docs.deeztek.com/books/hermes-seg-administrator-guide)
- [Hermes SEG User Guide](https://docs.deeztek.com/books/hermes-seg-user-guide)
- [Getting Started Guide](https://docs.deeztek.com/books/hermes-seg-administrator-guide/page/getting-started)
- [Release Notes](RELEASE-NOTES.md)

## Support

Post your questions at:
[https://github.com/deeztek/Hermes-Secure-Email-Gateway/discussions](https://github.com/deeztek/Hermes-Secure-Email-Gateway/discussions)

Chat with us on Matrix:
[https://matrix.to/#/#hermesseg:matrix.org](https://matrix.to/#/#hermesseg:matrix.org)

## Bugs

Bugs can be posted on our GitHub Issues at:
[https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues](https://github.com/deeztek/Hermes-Secure-Email-Gateway/issues)

## License

Hermes Secure Email Gateway Community Edition is free software licensed under the [GNU Affero General Public License v3.0](https://www.gnu.org/licenses/agpl.html).

Copyright Dionyssios Edwards 2011-2026. All Rights Reserved.
