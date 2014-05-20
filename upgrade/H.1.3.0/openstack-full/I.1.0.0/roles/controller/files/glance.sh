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

echo "### 1. Upgrade Glance database"
echo "#### FROM : non-UTF8"
echo "#### TO   : UTF8"

cat > glance.sql <<EOF
ALTER DATABASE glance CHARACTER SET utf8 COLLATE utf8_unicode_ci;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE migrate_version CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;
ALTER TABLE image_locations CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;
ALTER TABLE image_members CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;
ALTER TABLE image_properties CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;
ALTER TABLE image_tags CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;
ALTER TABLE images CONVERT TO CHARACTER SET utf8 COLLATE utf8_unicode_ci;
SET FOREIGN_KEY_CHECKS=1;
EOF

# Perform table upgrade
mysql -D glance < glance.sql

rm glance.sql
# glance.sh ends here
