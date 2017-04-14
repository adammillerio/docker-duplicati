FROM lsiobase/alpine:3.5
MAINTAINER sparklyballs

# environment settings
ENV HOME="/config"

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# install packages
RUN \
 apk add --no-cache \
	curl \
	tar \
	unzip && \
 apk add --no-cache \
	--repository http://nl.alpinelinux.org/alpine/edge/testing \
	mono && \

# install duplicati
 mkdir -p \
	/app/duplicati && \
 duplicati_tag=$(curl -sX GET "https://api.github.com/repos/duplicati/duplicati/releases" \
	| awk '/tag_name/{print $4;exit}' FS='[""]') && \
 duplicati_zip="duplicati-${duplicati_tag#*-}.zip" && \
 curl -o \
 /tmp/duplicati.zip -L \
	"https://github.com/duplicati/duplicati/releases/download/${duplicati_tag}/${duplicati_zip}" && \
 unzip -q /tmp/duplicati.zip -d /app/duplicati && \

# cleanup
 rm -rf \
	/tmp/*

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 8200
VOLUME /config
