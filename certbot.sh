# Ubuntu 18, 20 - Stable
# Ubuntu 22 > - In progress
# TODO: Make this compatible with Apache
# Find instructions for other OSes here: https://certbot.eff.org/instructions

# Install Certbot via Snaps
sudo snap install core; sudo snap refresh core
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/bin/certbot

# Install DNS CloudFlare plugin
sudo snap set certbot trust-plugin-with-root=ok
sudo snap install certbot-dns-cloudflare

# This directory may not exist yet
sudo mkdir -p /etc/letsencrypt


# Create file with the Cloudflare API token
sudo tee /etc/letsencrypt/dnscloudflare.ini > /dev/null <<EOT
# Cloudflare API token used by Certbot
dns_cloudflare_api_token = AN_API_TOKEN_HERE
EOT

# Secure that file (otherwise certbot yells at you)
sudo chmod 0600 /etc/letsencrypt/dnscloudflare.ini

# Create a certificate!
# This has nginx reload upon renewal,
# which assumes Nginx is using the created certificate
# You can also create non-wildcard subdomains, e.g. "-d foo.example.org"
sudo certbot certonly -d *.example.org \
    --dns-cloudflare --dns-cloudflare-credentials /etc/letsencrypt/dnscloudflare.ini \
    --post-hook "service nginx reload" \
    --non-interactive --agree-tos \
    --email someone-who-pays-attention-to-emails@example.org

# Test it out
sudo certbot renew --dry-run
