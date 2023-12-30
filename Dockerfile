# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.19

# set version label
ARG BUILD_DATE
ARG VERSION
ARG APP_VERSION
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="thespad"
LABEL org.opencontainers.image.source="https://github.com/thespad/docker-planka"
LABEL org.opencontainers.image.url="https://github.com/thespad/docker-planka"
LABEL org.opencontainers.image.description="Elegant open source project tracking."

RUN \
  echo "**** install packages ****" && \
  apk add  --no-cache --virtual=build-dependencies \
    build-base \
    npm \
    python3-dev && \
  apk add  --no-cache \
    giflib \
    libgsf \
    nodejs \
    vips && \
  echo "**** install planka ****" && \
  if [ -z ${APP_VERSION+x} ]; then \
    APP_VERSION=$(curl -s https://api.github.com/repos/plankanban/planka/releases/latest \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  mkdir -p /app/public && \
  mkdir -p /app/views && \
  mkdir -p /build && \
  curl -o \
    /tmp/planka.tar.gz -L \
    "https://github.com/plankanban/planka/archive/refs/tags/${APP_VERSION}.tar.gz" && \
  tar xf \
    /tmp/planka.tar.gz -C \
    /build --strip-components=1 && \
  cd /build/server && \
  npm clean-install --omit=dev && \
  cd /build/client && \
  npm clean-install --omit=dev && \
  DISABLE_ESLINT_PLUGIN=true npm run build && \
  mv /build/server/* /app && \
  mv /build/server/.env.sample /app/.env && \
  mv /build/server/.sailsrc /app/.sailsrc && \
  mv /build/client/build/* /app/public && \
  mv /app/public/index.html /app/views/index.ejs && \
  echo "**** cleanup ****" && \
  apk del --purge \
    build-dependencies && \
  rm -rf \
    $HOME/.cache \
    $HOME/.npm \
    /tmp/* \
    /build

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 1337

VOLUME /config
