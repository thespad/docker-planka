# [thespad/planka](https://github.com/thespad/docker-planka)

[![GitHub Release](https://img.shields.io/github/release/thespad/docker-planka.svg?color=26689A&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/thespad/docker-planka/releases)
![Commits](https://img.shields.io/github/commits-since/thespad/docker-planka/latest?color=26689A&include_prereleases&logo=github&style=for-the-badge)
![Image Size](https://img.shields.io/docker/image-size/thespad/planka/latest?color=26689A&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=Size)
[![Docker Pulls](https://img.shields.io/docker/pulls/thespad/planka.svg?color=26689A&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=pulls&logo=docker)](https://hub.docker.com/r/thespad/planka)
[![GitHub Stars](https://img.shields.io/github/stars/thespad/docker-planka.svg?color=26689A&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github)](https://github.com/thespad/docker-planka)
[![Docker Stars](https://img.shields.io/docker/stars/thespad/planka.svg?color=26689A&labelColor=555555&logoColor=ffffff&style=for-the-badge&label=stars&logo=docker)](https://hub.docker.com/r/thespad/planka)

[![ci](https://img.shields.io/github/actions/workflow/status/thespad/docker-planka/call-check-and-release.yml?branch=main&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github&label=Check%20For%20Upstream%20Updates)](https://github.com/thespad/docker-planka/actions/workflows/call-check-and-release.yml)
[![ci](https://img.shields.io/github/actions/workflow/status/thespad/docker-planka/call-baseimage-update.yml?branch=main&labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github&label=Check%20For%20Baseimage%20Updates)](https://github.com/thespad/docker-planka/actions/workflows/call-baseimage-update.yml)
[![ci](https://img.shields.io/github/actions/workflow/status/thespad/docker-planka/call-build-image.yml?labelColor=555555&logoColor=ffffff&style=for-the-badge&logo=github&label=Build%20Image)](https://github.com/thespad/docker-planka/actions/workflows/call-build-image.yml)

[Planka](https://github.com/plankanban/planka/) is an elegant open source project tracking tool.

## Supported Architectures

Our images support multiple architectures such as `x86-64`, `arm64` and `armhf`.

Simply pulling `ghcr.io/thespad/planka` should retrieve the correct image for your arch.

The architectures supported by this image are:

| Architecture | Available | Tag |
| :----: | :----: | ---- |
| x86-64 | ✅ | latest |
| arm64 | ✅ | latest |

## Application Setup

Web UI is accessible at `http://SERVERIP:PORT`. An external postgres database is required.

Default login is `demo@demo.demo` with a password of `demo`. Once you've created your own user account be sure to login to it and delete the `demo` account.

### Migration from Official Image

Copy your `user-avatars`, `project-background-images`, and `attachments` folders to your new `/config` mount so that it looks like:

```text
/config
├── attachments
├── project-background-images
└── user-avatars
```

## Usage

Here are some example snippets to help you get started creating a container.

### docker-compose ([recommended](https://docs.linuxserver.io/general/docker-compose))

Compatible with docker-compose v2 schemas.

```yaml
---
version: "2.1"
services:
  planka:
    image: ghcr.io/thespad/planka:latest
    container_name: planka
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London
      - BASE_URL=https://planka.example.com
      - TRUST_PROXY=0
      - DATABASE_URL=postgresql://user:password@planka-db/planka
      - SECRET_KEY=abc123
    volumes:
      - /path/to/appdata/config:/config
    ports:
      - 1337:1337
    restart: unless-stopped
```

### docker cli

```shell
docker run -d \
  --name=planka \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -e BASE_URL=https://planka.example.com \
  -e TRUST_PROXY=0 \
  -e DATABASE_URL=postgresql://user:password@planka-db/planka \
  -e SECRET_KEY=abc123 \
  -p 1337:1337 \
  -v /path/to/appdata/config:/config \
  --restart unless-stopped \
  ghcr.io/thespad/planka
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:80` would expose port `80` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 1337` | Web UI. |
| `-e PUID=1000` | for UserID - see below for explanation. |
| `-e PGID=1000` | for GroupID - see below for explanation. |
| `-e TZ=Europe/London` | Specify a timezone to use e.g. Europe/London. |
| `-e BASE_URL=https://planka.example.com` | The URL you will use to access planka. |
| `-e TRUST_PROXY=0` | Set to `1` to trust upstream proxies if reverse proxying. |
| `-e DATABASE_URL=postgresql://user:password@planka-db/planka` | The URL to your postgres database. |
| `-e SECRET_KEY=abc123` | Set a random session key. |
| `-v /config` | Contains all relevant configuration files. |

## Environment variables from files (Docker secrets)

You can set any environment variable from a file by using a special prepend `FILE__`.

As an example:

```shell
-e FILE__PASSWORD=/run/secrets/mysecretpassword
```

Will set the environment variable `PASSWORD` based on the contents of the `/run/secrets/mysecretpassword` file.

## Umask for running applications

For all of our images we provide the ability to override the default umask settings for services started within the containers using the optional `-e UMASK=022` setting.
Keep in mind umask is not chmod it subtracts from permissions based on it's value it does not add. Please read up [here](https://en.wikipedia.org/wiki/Umask) before asking for support.

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```shell
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```

## Support Info

* Shell access whilst the container is running: `docker exec -it planka /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f planka`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. We do not recommend or support updating apps inside the container. Please consult the [Application Setup](#application-setup) section above to see if it is recommended for the image.

Below are the instructions for updating containers:

### Via Docker Compose

* Update all images: `docker-compose pull`
  * or update a single image: `docker-compose pull planka`
* Let compose update all containers as necessary: `docker-compose up -d`
  * or update a single container: `docker-compose up -d planka`
* You can also remove the old dangling images: `docker image prune`

### Via Docker Run

* Update the image: `docker pull ghcr.io/thespad/planka`
* Stop the running container: `docker stop planka`
* Delete the container: `docker rm planka`
* Recreate a new container with the same docker run parameters as instructed above (if mapped correctly to a host folder, your `/config` folder and settings will be preserved)
* You can also remove the old dangling images: `docker image prune`

### Image Update Notifications - Diun (Docker Image Update Notifier)

* We recommend [Diun](https://crazymax.dev/diun/) for update notifications. Other tools that automatically update containers unattended are not recommended or supported.

## Building locally

If you want to make local modifications to these images for development purposes or just to customize the logic:

```shell
git clone https://github.com/thespad/docker-planka.git
cd docker-planka
docker build \
  --no-cache \
  --pull \
  -t ghcr.io/thespad/planka:latest .
```

## Versions

* **17.03.24:** - Rebase to Alpine 3.19.
* **04.09.23:** - Initial Release.
