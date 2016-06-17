#!/usr/bin/bash -x

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source /etc/environment
source $DIR/../../lib/helpers.sh

echo "-------Bastion node, beginning writing all default values to etcd-------"

######################
#     IMAGES
######################

# TODO: this overloads the machine

etcd-set /bootstrap.service/images-base-bootstrapped true

etcd-set /images/gocron-logrotate       "index.docker.io/behance/docker-gocron-logrotate"
etcd-set /images/sumologic              "index.docker.io/behance/docker-sumologic:latest"
etcd-set /images/sumologic-syslog       "index.docker.io/behance/docker-sumologic:syslog-latest"
etcd-set /images/dd-agent               "index.docker.io/behance/docker-dd-agent:latest"
etcd-set /images/secrets-downloader     "index.docker.io/behance/docker-aws-secrets-downloader:latest"
etcd-set /images/ecr-login              "index.docker.io/behance/ecr-login:latest"
etcd-set /images/splunk                 "index.docker.io/adobeplatform/docker-splunk:latest"

etcd-set /bootstrap.service/images-bastion-bootstrapped true

etcd-set /images/klam-ssh               "index.docker.io/adobecloudops/klam-ssh:latest"

######################
#      SERVICES
######################

etcd-set /environment/services "sumologic datadog"

echo "-------Bastion node, done writing all default values to etcd-------"
