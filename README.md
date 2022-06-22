# ns8-collabora

Start and configure a collabora instance.
The module uses [collabora Docker Image](https://hub.docker.com/r/collabora/code).

## Install

Instantiate the module with:

    add-module ghcr.io/nethserver/collabora:latest 1

The output of the command will return the instance name.
Output example:

    {"module_id": "collabora1", "image_name": "collabora", "image_url": "ghcr.io/nethserver/collabora:latest"}

## Configure

Let's assume that the collabora instance is named `collabora1`.

Launch `configure-module`, by setting the following parameters:
- `host`: a fully qualified domain name for the application
- `http2https`: enable or disable HTTP to HTTPS redirection
- `lets_encrypt`: enable or disable Let's Encrypt certificate
- `admin_password`: set a password for the admin console of collabora online

Example:

```
api-cli run configure-module --agent module/collabora1 --data - <<EOF
{
  "host": "collabora.domain.com",
  "http2https": true,
  "lets_encrypt": false,
  "admin_password": "password"
}
EOF
```

The above command will:
- start and configure the collabora instance
- configure a virtual host for traefik to access the instance

## Get the configuration
You can retrieve the configuration with

```
api-cli run get-configuration --agent module/collabora1 --data null | jq
```

## Uninstall

To uninstall the instance:

    remove-module --no-preserve collabora1

## Testing

Test the module using the `test-module.sh` script:


    ./test-module.sh <NODE_ADDR> ghcr.io/nethserver/collabora:latest

The tests are made using [Robot Framework](https://robotframework.org/)

## Enable Collabora inside Nextcloud

install nextcloud in ns8, then install Nextcloud Office (richdocuments) by the web interface of the administrator session (alternatively a bulk of default software is proposed at the first admin login creation, just accept it) then go to  Settings > Administration > Office and set the correct url to collabora (verify the certificate or not in case of self-signed)

or ssh to nextcloud and install it by hand

```
ssh nextcloud1@localhost
.config/bin/occ  app:install richdocuments
.config/bin/occ config:app:set richdocuments wopi_url --value=https://collabora.domain.com
.config/bin/occ app:enable richdocuments
```