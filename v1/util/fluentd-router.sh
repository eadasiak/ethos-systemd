#!/usr/bin/bash

if [[ -f /etc/profile.d/etcdctl.sh ]];
  then source /etc/profile.d/etcdctl.sh;
fi

source /etc/environment

IMAGE=$(etcdctl get /images/fluentd)
FLUENTD_ROUTER_PORT=$(etcdctl get /logging/config/fluentd-router-port)
FLUENTD_MONITOR_PORT=$(etcdctl get /logging/config/fluentd-monitor-port)

/usr/bin/docker run \
  --name fluentd-router \
  -p $FLUENTD_ROUTER_PORT:24224 \
  -p $FLUENTD_MONITOR_PORT:24220 \
  -e SPLUNK_API_USER_PASS=$(etcdctl get /splunk/config/api-user):$(etcdctl get /splunk/config/api-user-pass) \
  -e FLUENTD_HTTPEXT_BUFFER_TYPE=$(etcdctl get /logging/config/fluentd-httpext-buffer-type) \
  -e FLUENTD_HTTPEXT_BUFFER_QUEUE_LIMIT=$(etcdctl get /logging/config/fluentd-httpext-buffer-queue-limit) \
  -e FLUENTD_HTTPEXT_BUFFER_CHUNK_LIMIT=$(etcdctl get /logging/config/fluentd-httpext-buffer-chunk-limit) \
  -e FLUENTD_HTTPEXT_FLUSH_INTERVAL=$(etcdctl get /logging/config/fluentd-httpext-flush-interval) \
  -e FLUENTD_HTTPEXT_FLUSH_AT_SHUTDOWN=$(etcdctl get /logging/config/fluentd-httpext-flush-at-shutdown) \
  -e FLUENTD_HTTPEXT_RETRY_WAIT=$(etcdctl get /logging/config/fluentd-httpext-retry-wait) \
  -e FLUENTD_HTTPEXT_MAX_RETRY_WAIT=$(etcdctl get /logging/config/fluentd-httpext-max-retry-wait) \
  -e FLUENTD_HTTPEXT_RETRY_LIMIT=$(etcdctl get /logging/config/fluentd-httpext-retry-limit) \
  -e FLUENTD_HTTPEXT_DISABLE_RETRY_LIMIT=$(etcdctl get /logging/config/fluentd-httpext-disable-retry-limit) \
  -e FLUENTD_HTTPEXT_BUFFER_TYPE=$(etcdctl get /logging/config/fluentd-httpext-buffer-type) \
  -e FLUENTD_HTTPEXT_BUFFER_QUEUE_LIMIT=$(etcdctl get /logging/config/fluentd-httpext-buffer-queue-limit) \
  -e FLUENTD_HTTPEXT_BUFFER_CHUNK_LIMIT=$(etcdctl get /logging/config/fluentd-httpext-buffer-chunk-limit) \
  -e FLUENTD_HTTPEXT_FLUSH_INTERVAL=$(etcdctl get /logging/config/fluentd-httpext-flush-interval) \
  -e FLUENTD_HTTPEXT_FLUSH_AT_SHUTDOWN=$(etcdctl get /logging/config/fluentd-httpext-flush-at-shutdown) \
  -e FLUENTD_HTTPEXT_RETRY_WAIT=$(etcdctl get /logging/config/fluentd-httpext-retry-wait) \
  -e FLUENTD_HTTPEXT_MAX_RETRY_WAIT=$(etcdctl get /logging/config/fluentd-httpext-max-retry-wait) \
  -e FLUENTD_HTTPEXT_RETRY_LIMIT=$(etcdctl get /logging/config/fluentd-httpext-retry-limit) \
  -e FLUENTD_HTTPEXT_DISABLE_RETRY_LIMIT=$(etcdctl get /logging/config/fluentd-httpext-disable-retry-limit) \
  -e FLUENTD_HTTPEXT_ENDPOINT_URL=$(etcdctl get /logging/config/fluentd-httpext-endpoint-url) \
  -e FLUENTD_HTTPEXT_HTTP_METHOD=$(etcdctl get /logging/config/fluentd-httpext-http-method) \
  -e FLUENTD_HTTPEXT_SERIALIZER=$(etcdctl get /logging/config/fluentd-httpext-serializer) \
  -e FLUENTD_HTTPEXT_USE_SSL=$(etcdctl get /logging/config/fluentd-httpext-use-ssl) \
  -e FLUENTD_HTTPEXT_SPLUNK_HEC_TOKEN="$(etcdctl get /logging/config/fluentd-httpext-splunk-hec-token)" \
  -e FLUENTD_CONF=fluentd-router.conf \
  $IMAGE
