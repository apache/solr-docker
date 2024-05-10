#!/bin/bash

set -eo pipefail
set -x

docker-entrypoint.sh solr-foreground & 
./metrics-exporter.sh
