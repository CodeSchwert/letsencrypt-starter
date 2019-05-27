# Let's Encrypt Starter

Generate Let's Encrypt certs with Docker containers. Useful for bootstrapping nginx SSL server configurations.

## Generate Certs??

DNS records need be setup for the domain before attempting to generate certs.

```shell
# create working directories
sudo mkdir -p /etc/letsencrypt
sudo mkdir -p /opt/letsencrypt/www/.well-known/acme-challenge
sudo mkdir /opt/MyDir

# update user and group on instance (optional)
sudo chown ubuntu:ubuntu -R /opt/MyDir

cd /opt/MyDir 
git clone https://github.com/CodeSchwert/letsencrypt-starter.git
docker-compose run --rm -d -p 80:8080 http-server

# make sure to set the correct variables or command args!!!
# remove `--dry-run` when verification is working
docker-compose run certbot certonly --webroot -w /opt/letsencrypt/www -d $YOUR_DOMAIN --agree-tos --email $YOUR_EMAIL --dry-run

# cleanup the stack and images
docker-compose down
docker rmi letsencrypt-starter/http-server
```

The certs should now be in `/etc/letsencrypt/live/<domain>`. They can be used by nginx or other web servers.

## Port Bug

The `ports` directive in the `docker-compose.yml` file doesn't seem to map ports properly, hence running the separate `docker-compose run` commands with `-p` switch.

## Cert Renewal

The Let's Encrypt certificates are only valid for 3 months. To renew them, run:

```shell
docker run --rm -it \
  -v /etc/letsencrypt:/etc/letsencrypt \
  -v /opt/letsencrypt/www:/opt/letsencrypt/www \
  certbot/certbot renew -w /opt/letsencrypt/www --dry-run
```

The docker container doesn't seem to exit properly once the renew has completed. Wrapping the renew call in a script and checking for a touched renew file could be a workaround. See this github: https://github.com/certbot/certbot/issues/5333