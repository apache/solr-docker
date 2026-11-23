# Solr with JTS spatial support

The [official Apache Solr image](https://hub.docker.com/_/solr) plus the
[JTS Topology Suite](https://github.com/locationtech/jts) jar. Solr needs JTS for
`spatialContextFactory="JTS"` field types: polygons, multi-polygons and other WKT shapes.

The [Dockerfile](Dockerfile) is `FROM solr:<version>` plus one checksum-verified jar, so
the official image's patches and verification carry over.

## Using the image

```sh
podman pull ghcr.io/tufts-technology-services/solr-docker-spatial:9.11
```

| Tag | Meaning |
| --- | --- |
| `9.11` | The Solr minor version set in the Dockerfile |
| `latest` | The most recent build from `main` |
| `spatial-jts` | Same as `latest`; kept for deployments from when the image was built from the `spatial-jts` branch |

Every push to `main` builds and signs the image with cosign, and a weekly rebuild picks
up patch releases of the base image.

## Building locally

```sh
podman build -t solr-spatial:9.11 .
```

## Upgrading Solr

1. Change `ARG SOLR_VERSION` in the Dockerfile. The workflow reads this value to tag the
   image.
2. Look up the `jts-core` version in that Solr release's `versions.lock`. If it differs
   from `JTS_VERSION`, update `JTS_VERSION` and `JTS_SHA256`. Maven Central only
   publishes SHA-1 for the jar, so download it, compute the SHA-256, and check the
   download against Maven's SHA-1 first.
3. Check that `/opt/solr/server/solr-webapp/webapp/WEB-INF/lib/` still exists in the new
   image. Solr only loads JTS from there, not from its usual lib directories.

## License

[Apache License, Version 2.0](LICENSE).
