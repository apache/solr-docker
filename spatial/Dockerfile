# syntax=docker/dockerfile:1

# Official Solr image plus the JTS Topology Suite, which Solr needs for
# JTS-backed spatial fields (polygons, WKT shapes).
#
# Build: docker build --build-arg SOLR_VERSION=9.11 -t solr-spatial:9.11 spatial

ARG SOLR_VERSION=9.11
FROM solr:${SOLR_VERSION}

# Keep JTS_VERSION in step with the jts-core version in Solr's versions.lock.
# Maven Central only publishes SHA-1 for this jar; the SHA-256 below was
# computed from the download and checked against Maven's published SHA-1.
ARG JTS_VERSION=1.19.0
ARG JTS_SHA256=dbb8644cf324123d06c27aa982f570811e10b4cb1f2aef893b00de237d33efc0

USER root
# Solr only loads JTS from WEB-INF/lib, not from its usual lib directories.
ADD --checksum=sha256:${JTS_SHA256} --chown=solr:solr \
    https://repo1.maven.org/maven2/org/locationtech/jts/jts-core/${JTS_VERSION}/jts-core-${JTS_VERSION}.jar \
    /opt/solr/server/solr-webapp/webapp/WEB-INF/lib/
USER solr
