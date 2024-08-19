#!/bin/bash

while true; do
    RESULT=$(curl -s -o /dev/null -I -w '%{http_code}' -u "${SOLR_USER}:${SOLR_PASSWORD}" http://${CLUSTER_NAME}.${POD_NAMESPACE}.svc.cluster.local:8983/solr/admin/cores?action=STATUS)
    if [ "$RESULT" -eq '200' ]; then
        break
    fi
    sleep 1
done

if [[ "${SECURITY_ENABLED}" == "true" ]]; then
    /opt/solr/contrib/prometheus-exporter/bin/solr-exporter -p 9854 -z ${ZK_HOST} -f /opt/solr/contrib/prometheus-exporter/conf/solr-exporter-config.xml -n 16 -u "${SOLR_USER}:${SOLR_PASSWORD}"
else
    /opt/solr/contrib/prometheus-exporter/bin/solr-exporter -p 9854 -z ${ZK_HOST} -f /opt/solr/contrib/prometheus-exporter/conf/solr-exporter-config.xml -n 16
fi
