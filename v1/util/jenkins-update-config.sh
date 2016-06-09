#!/usr/bin/bash -x

JENKINS_DIRECTORY=$1

USAGE_MESSAGE="Control Jenkins: Please provide the Jenkins home directory"

if [[ ! $1 ]]; then
  echo "$USAGE_MESSAGE"
  exit 1;
fi

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $DIR/../lib/helpers.sh

CONTROL_JENKINS_OKTA_METADATA=$(etcd-get /jenkins/config/okta/metadata)
CONTROL_JENKINS_ADMIN_GROUP=$(etcd-get /jenkins/config/okta/admin-group)
CONTROL_JENKINS_RO_GROUP=$(etcd-get /jenkins/config/okta/read-group)

if [[ -n $CONTROL_JENKINS_OKTA_METADATA && -n $CONTROL_JENKINS_ADMIN_GROUP && -n $CONTROL_JENKINS_RO_GROUP ]] ; then
  # use the secure Jenkins config
  mv -f $JENKINS_DIRECTORY/config-secure.xml $JENKINS_DIRECTORY/config.xml

  # replace the admin group
  sed -i "s/\[CONTROL_JENKINS_ADMIN_GROUP\]/${CONTROL_JENKINS_ADMIN_GROUP}/g" $JENKINS_DIRECTORY/config.xml
  # replace the read only group
  sed -i "s/\[CONTROL_JENKINS_RO_GROUP\]/${CONTROL_JENKINS_RO_GROUP}/g" $JENKINS_DIRECTORY/config.xml

  # decode from base64, encode the xml entities and escape awk special characters
  ESCAPED_DATA="$(echo "${CONTROL_JENKINS_OKTA_METADATA}" | base64 --decode | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g; s/"/\&quot;/g; s/'"'"'/\&#39;/g;' | sed -e 's/[\&]/\\\\&/g')"

  # replace the label with the sanitized text and save in tmp file
  awk -v r="${ESCAPED_DATA}" '{gsub(/\[CONTROL_JENKINS_OKTA_METADATA\]/,r); print $0}' $JENKINS_DIRECTORY/config.xml > /var/tmp/config.xml

  # replace the config file
  cp -f /var/tmp/config.xml $JENKINS_DIRECTORY/config.xml

  # remove temporary file
  rm -f /var/tmp/config.xml

  echo "Control Jenkins: Updated Okta configuration"
else
  echo "Control Jenkins: Using insecure configuration"
fi
