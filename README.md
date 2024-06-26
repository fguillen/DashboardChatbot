# DashboardChatbot

## Skeleton

This project has been created using this Rails template:

- https://github.com/fguillen/RailsSkeleton

Check there for:

- dependencies
- deployment
- configuration
- structure
- ...

## Assets

- Design Template: https://www.figma.com/community/file/1233718968112636464/ai-chatbot-ui-kit


# Development

## Set dummy certs for Docker web container

```
BASE_PATH="./data/certbot"
CERT_PATH="/etc/letsencrypt/live/dashboardchatbot.com"
mkdir -p $BASE_PATH/conf/live/dashboardchatbot.com
curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$BASE_PATH/conf/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$BASE_PATH/conf/ssl-dhparams.pem"
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:4096 -days 1\
    -keyout '$CERT_PATH/privkey.pem' \
    -out '$CERT_PATH/fullchain.pem' \
    -subj '/CN=localhost'" certbot
```
