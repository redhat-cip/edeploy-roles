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
# Upgrade Neutron database to have UTF8 charset.
#

set -ex

echo "### 1. Upgrade Neutron database"
echo "#### FROM : non-UTF8"
echo "#### TO   : UTF8"

# Dump the DB and recreate a new one
mysqldump --add-drop-table neutron | replace CHARSET=latin1 CHARSET=utf8 | iconv -f latin1 -t utf8 > neutron-utf8.sql
mysql -e 'DROP DATABASE neutron'
mysql -e 'CREATE DATABASE neutron'

# Perform table upgrade
mysql -D neutron < neutron-utf8.sql

rm neutron-utf8.sql
# neutron.sh ends here
