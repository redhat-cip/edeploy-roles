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

# Script that jenkins is up and running

set -e
set -x

if ! timeout 1000 sh -c "while ! curl -s http://localhost:8282 | grep 'No builds in the queue.' >/dev/null 2>&1; do sleep 10; done"; then
  echo "install-server failed to upgrade:"
  echo "Jenkins is not up and running after long time."
  exit 1
fi

exit 0
