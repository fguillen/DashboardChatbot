# DashboardChatbot

## Theme

- https://themes.getbootstrap.com/product/phoenix-admin-dashboard-webapp-template/

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
CERT_PATH="/etc/letsencrypt/live/sales-api.kelmia.com"
mkdir -p $BASE_PATH/conf/live/sales-api.kelmia.com
curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$BASE_PATH/conf/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$BASE_PATH/conf/ssl-dhparams.pem"
docker compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:4096 -days 1\
    -keyout '$CERT_PATH/privkey.pem' \
    -out '$CERT_PATH/fullchain.pem' \
    -subj '/CN=localhost'" certbot
```

### Start the app

(Included in the server_setup.sh script)

    cd /var/apps/RailsSkeleton
    docker compose build
    docker compose up -d
    docker compose exec app bundle exec rake db:create db:schema:load
    (docker compose exec app bundle exec rake db:seed) # Optional

### Redeploy

    cd /var/apps/RailsSkeleton
    git pull

Running migrations:

    docker compose exec app bundle exec rake db:migrate data:migrate assets:precompile

Restart the app:

    docker compose restart app
    docker compose restart cron
    docker compose restart web

Or maybe

    docker compose down
    docker compose up -d

### Docker

#### Consoling

    docker compose exec app bundle exec rails c
    docker compose exec app bash
    docker compose exec db mysql -uroot -proot
    docker compose exec web bash
    docker compose run --rm --entrypoint "/bin/sh" certbot
    docker compose run --rm --entrypoint "/bin/bash" web

#### Logs

    docker compose logs

#### Nginx reload

    docker compose exec web nginx -s reload


## Bugs found

- https://community.openai.com/t/chatgpt-occasionally-reuses-tool-ids-in-the-same-session/577207
- https://community.openai.com/t/parallel-assistant-function-calls-returning-undocumented-function-multi-tool-use-parallel/697047
