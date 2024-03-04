#!/bin/bash

# Install ssmtp
sudo apt-get update
sudo apt-get install ssmtp -y

# Backup the original ssmtp.conf file
sudo cp /etc/ssmtp/ssmtp.conf /etc/ssmtp/ssmtp.conf.backup

# Configure ssmtp
sudo tee /etc/ssmtp/ssmtp.conf > /dev/null <<EOT
root=[FROM EMAIL]
mailhub=smtp.postmarkapp.com:587
AuthUser=[API KEY]
AuthPass=[API KEY]
UseSTARTTLS=YES
EOT

# Create ssh.sh under root home folder
sudo tee /root/ssh.sh > /dev/null <<'EOF'
#!/bin/bash

# Define the file paths and initial line number if not already set
LAST_LINE_FILE="/tmp/last_ssh_line.txt"
if [ ! -f "$LAST_LINE_FILE" ]; then
    echo "0" > "$LAST_LINE_FILE"
fi

# Read the last processed line number and update to the current last line
LAST_LINE_NUMBER=$(cat "$LAST_LINE_FILE")
NEW_LAST_LINE_NUMBER=$(wc -l /var/log/auth.log | cut -d " " -f 1)
echo "$NEW_LAST_LINE_NUMBER" > "$LAST_LINE_FILE"

# Extract new login attempts
LOGIN_ATTEMPTS=$(tail -n +$((LAST_LINE_NUMBER+1)) /var/log/auth.log | grep 'sshd.*Accepted')

# Proceed if new logins are found
if [ ! -z "$LOGIN_ATTEMPTS" ]; then
    # Email content setup
    SUBJECT="SSH Login Alert - $(hostname)"
    TO="[TO EMAIL]"
    FROM="[FROM EMAIL]"
    EMAIL_BODY="New SSH login detected:\n$LOGIN_ATTEMPTS"
    
    # Prepare email content
    echo -e "To: $TO\nFrom: $FROM\nSubject: $SUBJECT\n\n$EMAIL_BODY" > /tmp/email.txt

    # Send the email
    /usr/sbin/ssmtp "$TO" < /tmp/email.txt
fi
EOF

# Make the script executable
sudo chmod +x /root/ssh.sh

# Set up cron job to run the script every minute
(crontab -l 2>/dev/null; echo "* * * * * /root/ssh.sh") | crontab -

echo "ssmtp has been installed and configured. ssh.sh script created and cron job set."
