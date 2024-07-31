# Discourse Installation Script for Ubuntu

This script automates the installation of a production-ready Discourse site on Ubuntu. It simplifies the process of setting up Discourse by handling the installation of dependencies, configuration, and deployment using Docker.

## Prerequisites

- Ubuntu 20.04 LTS or later
- Sudo privileges
- A domain name pointing to your server's IP address

## Installation

1. Clone this repository or download the `install_discourse.sh` script to your Ubuntu server.

2. Create a `.env` file in the same directory as the script with the following content:

   ```
   DISCOURSE_HOSTNAME=your_domain.com
   DISCOURSE_DEVELOPER_EMAILS=your_email@example.com
   DISCOURSE_SMTP_ADDRESS=smtp.example.com
   DISCOURSE_SMTP_PORT=587
   DISCOURSE_SMTP_USER_NAME=your_smtp_username
   DISCOURSE_SMTP_PASSWORD=your_smtp_password
   LETSENCRYPT_ACCOUNT_EMAIL=your_email@example.com
   DB_PASSWORD=your_db_password  # Optional
   REDIS_PASSWORD=your_redis_password  # Optional
   ```

   Replace the placeholder values with your actual information.

3. Make the script executable:

   ```
   chmod +x install_discourse.sh
   ```

4. Run the script with sudo privileges:

   ```
   sudo ./install_discourse.sh
   ```

5. Follow the on-screen prompts and wait for the installation to complete.

6. Once the installation is finished, visit `https://your_domain.com` to complete the Discourse setup process.

## Configuration

The script uses the values provided in the `.env` file to configure Discourse. Here's what each variable means:

- `DISCOURSE_HOSTNAME`: Your domain name (e.g., forum.example.com)
- `DISCOURSE_DEVELOPER_EMAILS`: Email address of the admin user
- `DISCOURSE_SMTP_ADDRESS`: SMTP server address for sending emails
- `DISCOURSE_SMTP_PORT`: SMTP server port (usually 587 for TLS)
- `DISCOURSE_SMTP_USER_NAME`: SMTP username
- `DISCOURSE_SMTP_PASSWORD`: SMTP password
- `LETSENCRYPT_ACCOUNT_EMAIL`: Email address for Let's Encrypt notifications
- `DB_PASSWORD`: (Optional) PostgreSQL database password
- `REDIS_PASSWORD`: (Optional) Redis password

If `DB_PASSWORD` and `REDIS_PASSWORD` are not provided, the script will generate random passwords.

## Important Notes

- This script is intended for a fresh installation on a clean Ubuntu system. Running it on a system with existing Docker configurations or another web server might cause conflicts.
- Make sure your domain's DNS is properly configured to point to your server before running the script.
- The script will install Docker and Docker Compose if they are not already present on your system.
- After installation, it's recommended to secure your server further by setting up a firewall and keeping the system updated.
- Regularly backup your Discourse data and keep your system and Discourse installation up to date.

## Troubleshooting

If you encounter any issues during installation:

1. Check the Discourse logs:
   ```
   cd /opt/discourse
   sudo ./launcher logs app
   ```

2. Ensure all required ports (80, 443) are open and not in use by other applications.

3. Verify that your `.env` file contains all required variables and that they are correctly set.

4. If you need to rebuild the Discourse container:
   ```
   cd /opt/discourse
   sudo ./launcher rebuild app
   ```

For more detailed troubleshooting and customization options, refer to the [official Discourse Docker documentation](https://github.com/discourse/discourse/blob/master/docs/INSTALL-cloud.md).

## Support

For issues related to this installation script, please open an issue in this repository.

For general Discourse support, visit the [official Discourse meta forum](https://meta.discourse.org/).

Remember to keep your `.env` file and any logs containing sensitive information secure and never share them publicly when seeking support.