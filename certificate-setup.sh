#!/bin/sh
# Check nginx configuration and reload it if it's valid
nginx -t && nginx -s reload

# Check if certificate exists
if [ ! -d "/etc/letsencrypt/live/$CERTBOT_DOMAIN" ]; then
  # Obtain Let's Encrypt certificate
  certbot --nginx -d $CERTBOT_DOMAIN --non-interactive --agree-tos --email $CERTBOT_EMAIL --redirect
else
  # Ensure Nginx is configured to use the existing certificate and set up the redirection
  certbot --nginx --keep -d $CERTBOT_DOMAIN --non-interactive --agree-tos --email $CERTBOT_EMAIL --redirect
  # Renew Let's Encrypt certificate if due and reload Nginx if a certificate is actually renewed
  certbot renew --deploy-hook "nginx -s reload"
  # Ensure Nginx is configured to use the certificate
  certbot install --nginx --cert-name $CERTBOT_DOMAIN --non-interactive
fi
# Stop nginx
nginx -s stop