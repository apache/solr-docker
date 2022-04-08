# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


FROM eclipse-temurin:17-jre

# TODO: remove things that exist solely for downstream specialization since Dockerfile.local now exists for that
# TODO: replace 3rd party keyservers with official Apache Solr KEYS url

ARG SOLR_VERSION="9.0.0"
ARG SOLR_SHA512="1d8ab968dfd8b169a647fe4aa75b11c44b656974a834492a69c964233ad65310c3d0cd1eeebf7bc15167aa4b5af498f345943f0b4b3fb817450686cbe1e6a4da"
ARG SOLR_KEYS="0D8D0B93"

# If specified, this will override SOLR_DOWNLOAD_SERVER and all ASF mirrors. Typically used downstream for custom builds
ARG SOLR_DOWNLOAD_URL
# TODO: That comment isn't strictly true, if SOLR_DOWNLOAD_URL fails, other mirrors will be attempted
# TODO: see patch in SOLR-15250 for some example ideas on fixing this to be more strict

# Override the default solr download location with a prefered mirror, e.g.:
#   docker build -t mine --build-arg SOLR_DOWNLOAD_SERVER=https://downloads.apache.org/solr/solr .
ARG SOLR_DOWNLOAD_SERVER

# These should never be overridden except for the purposes of testing the Dockerfile before release
ARG SOLR_CLOSER_URL="http://www.apache.org/dyn/closer.lua/solr/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz?action=download"
ARG SOLR_DIST_URL="https://www.apache.org/dist/solr/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz"
ARG SOLR_ARCHIVE_URL="https://archive.apache.org/dist/solr/solr/$SOLR_VERSION/solr-$SOLR_VERSION.tgz"

RUN set -ex; \
  apt-get update; \
  apt-get -y install wget gpg; \
  rm -rf /var/lib/apt/lists/*; \
  export GNUPGHOME="/tmp/gnupg_home"; \
  mkdir -p "$GNUPGHOME"; \
  chmod 700 "$GNUPGHOME"; \
  echo "disable-ipv6" >> "$GNUPGHOME/dirmngr.conf"; \
  for key in $SOLR_KEYS; do \
    found=''; \
    for server in \
      ha.pool.sks-keyservers.net \
      hkp://keyserver.ubuntu.com:80 \
      hkp://p80.pool.sks-keyservers.net:80 \
      pgp.mit.edu \
    ; do \
      echo "  trying $server for $key"; \
      gpg --batch --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$key" && found=yes && break; \
      gpg --batch --keyserver "$server" --keyserver-options timeout=10 --recv-keys "$key" && found=yes && break; \
    done; \
    test -z "$found" && echo >&2 "error: failed to fetch $key from several disparate servers -- network issues?" && exit 1; \
  done; \
  MAX_REDIRECTS=1; \
  if [ -n "$SOLR_DOWNLOAD_URL" ]; then \
    # If a custom URL is defined, we download from non-ASF mirror URL and allow more redirects and skip GPG step
    # This takes effect only if the SOLR_DOWNLOAD_URL build-arg is specified, typically in downstream Dockerfiles
    MAX_REDIRECTS=4; \
    SKIP_GPG_CHECK=true; \
  elif [ -n "$SOLR_DOWNLOAD_SERVER" ]; then \
    SOLR_DOWNLOAD_URL="$SOLR_DOWNLOAD_SERVER/$SOLR_VERSION/solr-$SOLR_VERSION.tgz"; \
  fi; \
  for url in $SOLR_DOWNLOAD_URL $SOLR_CLOSER_URL $SOLR_DIST_URL $SOLR_ARCHIVE_URL; do \
    if [ -f "/opt/solr-$SOLR_VERSION.tgz" ]; then break; fi; \
    echo "downloading $url"; \
    if wget -t 10 --max-redirect $MAX_REDIRECTS --retry-connrefused -nv "$url" -O "/opt/solr-$SOLR_VERSION.tgz"; then break; else rm -f "/opt/solr-$SOLR_VERSION.tgz"; fi; \
  done; \
  if [ ! -f "/opt/solr-$SOLR_VERSION.tgz" ]; then echo "failed all download attempts for solr-$SOLR_VERSION.tgz"; exit 1; fi; \
  if [ -z "$SKIP_GPG_CHECK" ]; then \
    echo "downloading $SOLR_ARCHIVE_URL.asc"; \
    wget -nv "$SOLR_ARCHIVE_URL.asc" -O "/opt/solr-$SOLR_VERSION.tgz.asc"; \
    echo "$SOLR_SHA512 */opt/solr-$SOLR_VERSION.tgz" | sha512sum -c -; \
    (>&2 ls -l "/opt/solr-$SOLR_VERSION.tgz" "/opt/solr-$SOLR_VERSION.tgz.asc"); \
    gpg --batch --verify "/opt/solr-$SOLR_VERSION.tgz.asc" "/opt/solr-$SOLR_VERSION.tgz"; \
  else \
    echo "Skipping GPG validation due to non-Apache build"; \
  fi; \
  { command -v gpgconf; gpgconf --kill all || :; }; \
  rm -r "$GNUPGHOME"; \
  tar -C /opt --extract --preserve-permissions --file "/opt/solr-$SOLR_VERSION.tgz"; \
  rm "/opt/solr-$SOLR_VERSION.tgz"*;



# add symlink to /opt/solr, remove what we don't want.
# Remove the Dockerfile because it might not represent the dockerfile that was used to generate the image.
RUN set -ex; \
  (cd /opt; ln -s solr-*/ solr); \
  rm -Rf /opt/solr/docs /opt/solr/docker/Dockerfile;

LABEL maintainer="The Apache Solr Project"
LABEL url="https://solr.apache.org"
LABEL repository="https://github.com/apache/solr"

RUN set -ex; \
    apt-get update; \
    apt-get -y install acl dirmngr lsof procps wget netcat gosu tini jattach; \
    rm -rf /var/lib/apt/lists/*;

ENV SOLR_USER="solr" \
    SOLR_UID="8983" \
    SOLR_GROUP="solr" \
    SOLR_GID="8983" \
    PATH="/opt/solr/bin:/opt/solr/docker/scripts:/opt/solr/prometheus-exporter/bin:$PATH" \
    SOLR_INCLUDE=/etc/default/solr.in.sh \
    SOLR_HOME=/var/solr/data \
    SOLR_PID_DIR=/var/solr \
    SOLR_LOGS_DIR=/var/solr/logs \
    LOG4J_PROPS=/var/solr/log4j2.xml \
    SOLR_JETTY_HOST="0.0.0.0"

RUN set -ex; \
  groupadd -r --gid "$SOLR_GID" "$SOLR_GROUP"; \
  useradd -r --uid "$SOLR_UID" --gid "$SOLR_GID" "$SOLR_USER"

RUN set -ex; \
  mkdir -p /opt/solr/server/solr/lib /docker-entrypoint-initdb.d; \
  cp /opt/solr/bin/solr.in.sh /etc/default/solr.in.sh; \
  mv /opt/solr/bin/solr.in.sh /opt/solr/bin/solr.in.sh.orig; \
  mv /opt/solr/bin/solr.in.cmd /opt/solr/bin/solr.in.cmd.orig; \
  chmod 0664 /etc/default/solr.in.sh; \
  mkdir -p -m0770 /var/solr; \
  chown -R "$SOLR_USER:0" /var/solr; \
  ln -s /opt/solr/modules /opt/solr/contrib; \
  ln -s /opt/solr/prometheus-exporter /opt/solr/modules/prometheus-exporter;

VOLUME /var/solr
EXPOSE 8983
WORKDIR /opt/solr
USER $SOLR_USER

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["solr-foreground"]
