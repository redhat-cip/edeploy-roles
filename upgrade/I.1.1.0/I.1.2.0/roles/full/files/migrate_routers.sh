#!/bin/sh
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
# Migrate all routers from a network server before upgrade
# We consider that neutron-l3-agent is already stopped on the node
# where we run this script.

set -e
set -x

DIR=$(cd $(dirname $0); pwd)

# Need to use OpenStack admin credentials to perform migrations
export OS_USERNAME=$1
export OS_TENANT_NAME=$2
export OS_PASSWORD=$3
export OS_AUTH_URL=$4

if pgrep neutron-l3-agent > /dev/null; then
    echo "L3 Agent is running running, migration can't happen on this node."
    exit 1
else
    echo "L3 Agent is off, migration of routers is starting."
    # Migrate routers away from this L3 agent, with debug and without waiting
    python $DIR/neutron-ha-tool.py -d --l3-agent-migrate --now
    echo "Migration of routers is finished."
fi
