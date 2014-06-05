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
# Upgrade keystone database to have UTF8 charset.
#

set -ex

echo "### 1. Upgrade Keystone database"
echo "#### FROM : non-UTF8"
echo "#### TO   : UTF8"

cat > keystone.sql <<EOF
ALTER DATABASE keystone CHARACTER SET utf8 COLLATE utf8_unicode_ci;
EOF

# Perform table upgrade
mysql -D keystone < keystone.sql

rm keystone.sql
# keystone.sh ends here
