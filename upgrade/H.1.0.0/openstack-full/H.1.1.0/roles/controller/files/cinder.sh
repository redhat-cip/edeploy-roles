#!/bin/bash
#
# Copyright (C) 2014 eNovance SAS <licensing@enovance.com>
#
# Author: Emilien Macchi <emilien.macchi@enovance.com>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# Upgrade Cinder to support multi-backend when having
# an existing RBD driver configured.
#

set -ex

echo "### 1. Upgrade Cinder"
echo "#### FROM : RBD mono-backend"
echo "#### TO   : RBD multi-backend"

OS_USERNAME=$1
OS_TENANT_NAME=$2
OS_PASSWORD=$3
OS_AUTH_URL=$4

VOLUME_TYPE_ID=$(cinder --os-username $OS_USERNAME --os-tenant-name $OSE_TENANT_NAME --os-password $OS_PASSWORD --os-auth-url $OS_AUTH_URL extra-specs-list | awk '/ ceph /{print $2}')

echo "update volumes set volume_type_id='$VOLUME_TYPE_ID' where volume_type_id='';">cinder.sql

# Where cinder-volume used to run
for i in 3 8 12;
  do echo "update volumes set host='os-ci-test$i@ceph' where host='os-ci-test$i';">>cinder.sql
done

# Perform table upgrade
mysql -D cinder < cinder.sql

rm cinder.sql
# cinder.sh ends here
