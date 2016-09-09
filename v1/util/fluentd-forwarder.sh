#!/usr/bin/bash

if [[ -f /etc/profile.d/etcdctl.sh ]];
  then source /etc/profile.d/etcdctl.sh;
fi

IMAGE=$(etcdctl get /images/fluentd)
FLUENTD_FORWARDER_PORT=$(etcdctl get /logging/config/fluentd-router-port)
FLUENTD_MONITOR_PORT=$(etcdctl get /logging/config/fluentd-monitor-port)

/usr/bin/docker run \
  --name fluentd-forwarder \
  -p $FLUENTD_FORWARDER_PORT:5170 \
  -p $FLUENTD_MONITOR_PORT:24220 \
  -e FLUENTD_CONF=fluentd-forwarder.conf \
  -e FLUENTD_ROUTER_LB=$(etcdctl get /logging/config/fluentd-router-lb) \
  -e FLUENTD_ROUTER_PORT=$(etcdctl get /logging/config/fluentd-router-port) \
  -e FLUENTD_ETHOSPLUGIN_CACHE_SIZE=$(etcdctl get /logging/config/fluentd-ethosplugin-cache-size) \
  -e FLUENTD_ETHOSPLUGIN_CACHE_TTL=$(etcdctl get /logging/config/fluentd-ethosplugin-cache-ttl) \
  -e FLUENTD_ETHOSPLUGIN_GET_TAG_FLAG=$(etcdctl get /logging/config/fluentd-ethosplugin-get-tag-flag) \
  -e FLUENTD_ETHOSPLUGIN_CONTAINER_TAG=$(etcdctl get /logging/config/fluentd-ethosplugin-container-tag) \
  -e FLUENTD_ETHOSPLUGIN_LOGTYPE_RULE=$(etcdctl get /logging/config/fluentd-ethosplugin-logtype-rule) \
  -e FLUENTD_FORWARD_SEND_TIMEOUT=$(etcdctl get /logging/config/fluentd-forward-send-timeout) \
  -e FLUENTD_FORWARD_RECOVER_WAIT=$(etcdctl get /logging/config/fluentd-forward-recover-wait) \
  -e FLUENTD_FORWARD_HEARTBEAT_TYPE=$(etcdctl get /logging/config/fluentd-forward-heartbeat-type) \
  -e FLUENTD_FORWARD_HEARTBEAT_INTERVAL=$(etcdctl get /logging/config/fluentd-forward-heartbeat-interval) \
  -e FLUENTD_FORWARD_PHI_FAILURE_DETECTOR=$(etcdctl get /logging/config/fluentd-forward-phi-failure-detector) \
  -e FLUENTD_FORWARD_PHI_THRESHOLD=$(etcdctl get /logging/config/fluentd-forward-phi-threshold) \
  -e FLUENTD_FORWARD_HARD_TIMEOUT=$(etcdctl get /logging/config/fluentd-forward-hard-timeout) \
  -e FLUENTD_FORWARD_BUFFER_TYPE=$(etcdctl get /logging/config/fluentd-forward-buffer-type) \
  -e FLUENTD_FORWARD_BUFFER_QUEUE_LIMIT=$(etcdctl get /logging/config/fluentd-forward-buffer-queue-limit) \
  -e FLUENTD_FORWARD_BUFFER_CHUNK_LIMIT=$(etcdctl get /logging/config/fluentd-forward-buffer-chunk-limit) \
  -e FLUENTD_FORWARD_FLUSH_INTERVAL=$(etcdctl get /logging/config/fluentd-forward-flush-interval) \
  -e FLUENTD_FORWARD_FLUSH_AT_SHUTDOWN=$(etcdctl get /logging/config/fluentd-forward-flush-at-shutdown) \
  -e FLUENTD_FORWARD_RETRY_WAIT=$(etcdctl get /logging/config/fluentd-forward-retry-wait) \
  -e FLUENTD_FORWARD_MAX_RETRY_WAIT=$(etcdctl get /logging/config/fluentd-forward-max-retry-wait) \
  -e FLUENTD_FORWARD_RETRY_LIMIT=$(etcdctl get /logging/config/fluentd-forward-retry-limit) \
  -e FLUENTD_FORWARD_DISABLE_RETRY_LIMIT=$(etcdctl get /logging/config/fluentd-forward-disable-retry-limit) \
  -e FLUENTD_FORWARD_NUM_THREADS=$(etcdctl get /logging/config/fluentd-forward-num-threads) \
  -v /var/run/docker.sock:/var/run/docker.sock \
  $IMAGE
