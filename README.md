# ssh-login-email-alert

This project provides a script that monitors SSH login attempts on a server and sends email alerts for new logins. It's particularly useful for administrators looking to keep track of access to their servers. This script uses `ssmtp` for email sending, with Postmark recommended for SMTP service.

## Getting Started

These instructions will get you a copy of the project up and running on your server.

### Prerequisites

- A Linux server with SSH access.
- Permission to install packages and configure `ssmtp`.
- A Postmark account for SMTP services.

### Installation

1. Log in to your server as root or with sudo privileges.

2. Create the installation script:

```bash
nano ssh-email.sh
```
3. Remember to replace [FROM EMAIL], [API KEY], and [TO EMAIL] with your actual details.
4. Set the script to be executable and run it:
```
chmod +x ssh-email.sh && ./ssh-email.sh
```
This script will install ssmtp, configure it with your SMTP details, create a monitoring script in /root/ssh.sh, and set up a cron job to run this script every minute.
