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
# Upgrade Heat database to have UTF8 charset.
#

set -ex

echo "### 1. Upgrade Heat database"
echo "#### FROM : non-UTF8"
echo "#### TO   : UTF8"

# Dump the DB and recreate a new one
mysqldump --add-drop-table heat | replace CHARSET=latin1 CHARSET=utf8 | iconv -f latin1 -t utf8 > heat-utf8.sql
mysql -e 'DROP DATABASE heat'
mysql -e 'CREATE DATABASE heat'

# Perform table upgrade
mysql -D heat < heat-utf8.sql

rm heat-utf8.sql
# heat.sh ends here
