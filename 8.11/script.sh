#!/bin/bash
docker-entrypoint.sh solr-foreground &

# export JAVA_OPTS="-Djavax.net.ssl.trustStore=truststore.jks -Djavax.net.ssl.trustStorePassword=truststorePassword -Dsolr.httpclient.builder.factory=org.apache.solr.client.solrj.impl.PreemptiveBasicAuthClientBuilderFactory -Dsolr.httpclient.config=/opt/solr/basicauth.properties -DzkCredentialsProvider=org.apache.solr.common.cloud.VMParamsSingleSetCredentialsDigestZkCredentialsProvider"
# export CLASSPATH_PREFIX="/opt/solr/server/solr-webapp/webapp/WEB-INF/lib/commons-codec-1.11.jar"

export JAVA_OPTS="-Dsolr.httpclient.builder.factory=org.apache.solr.client.solrj.impl.PreemptiveBasicAuthClientBuilderFactory -Dsolr.httpclient.config=/opt/solr/basicauth.properties -DzkCredentialsProvider=org.apache.solr.common.cloud.VMParamsSingleSetCredentialsDigestZkCredentialsProvider"
# export CLASSPATH_PREFIX="/opt/solr/server/solr-webapp/webapp/WEB-INF/lib/commons-codec-1.11.jar"

while true; do
    RESULT=$(curl -s -o /dev/null -I -w '%{http_code}' -u "${SOLR_USER}:${SOLR_PASSWORD}" http://${CLUSTER_NAME}.${POD_NAMESPACE}.svc.cluster.local:8983/solr/admin/cores?action=STATUS)
    if [ "$RESULT" -eq '200' ]; then
        break
    fi
done

/opt/solr/contrib/prometheus-exporter/bin/solr-exporter -p 9854 -z ${ZK_HOST} -f /opt/solr/contrib/prometheus-exporter/conf/solr-exporter-config.xml -n 16

