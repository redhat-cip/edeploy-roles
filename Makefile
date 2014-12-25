#
# Copyright (C) 2013-2014 eNovance SAS <licensing@enovance.com>
#
# Author: Frederic Lepied <frederic.lepied@enovance.com>
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

# Exporting ALL variables to other childs
.EXPORT_ALL_VARIABLES:

MAKEFILE_DIR=$(shell pwd)
SDIR=/srv/edeploy
TOP=/var/lib/debootstrap
ARCHIVE=$(TOP)/install
DVER=D7
PVER=J
REL=1.0.0
VERSION:=$(PVER).$(REL)
VERS=$(DVER)-$(VERSION)
DIST=wheezy
BREL=1.7.0
BVERS=$(DVER)-$(BREL)

ARCH=amd64
export PATH := /sbin:/bin::$(PATH)

MAKEFILE_TARGET=$(MAKECMDGOALS)
CURRENT_TARGET=$@
export MAKEFILE_TARGET
export CURRENT_TARGET

INST=$(TOP)/install/$(VERS)
META=$(TOP)/metadata/$(VERS)

ROLES = cloud devstack openstack-common openstack-full mysql puppet-master install-server logcollector monitor-server\
        postgresql-server puppetdb-server

all: $(ROLES)

#sample: $(INST)/sample.done
#$(INST)/sample.done: sample.install $(INST)/base.done
#	./sample.install $(INST)/base $(INST)/sample $(VERS)
#	touch $(INST)/sample.done

cloud: $(INST)/cloud.done
$(INST)/cloud.done: cloud.install $(INST)/base.done
	./cloud.install $(INST)/base $(INST)/cloud $(VERS)
	touch $(INST)/cloud.done

devstack: $(INST)/devstack.done
$(INST)/devstack.done: devstack.install $(INST)/cloud.done
	./devstack.install $(INST)/cloud $(INST)/devstack $(DIST) $(VERS)
	touch $(INST)/devstack.done

logcollector: $(INST)/logcollector.done
$(INST)/logcollector.done: logcollector.install $(INST)/cloud.done
	./logcollector.install $(INST)/cloud $(INST)/logcollector $(VERS)
	touch $(INST)/logcollector.done

monitor-server: $(INST)/monitor-server.done
$(INST)/monitor-server.done: monitor-server.install $(INST)/cloud.done
	./monitor-server.install $(INST)/cloud $(INST)/monitor-server $(VERS)
	touch $(INST)/monitor-server.done

openstack-common: $(INST)/openstack-common.done
$(INST)/openstack-common.done: openstack-common.install $(INST)/cloud.done functions
	./openstack-common.install $(INST)/cloud $(INST)/openstack-common $(VERS)
	touch $(INST)/openstack-common.done

openstack-full: $(INST)/openstack-full.done
$(INST)/openstack-full.done: openstack-full.install $(INST)/openstack-common.done
	./openstack-full.install $(INST)/openstack-common $(INST)/openstack-full $(VERS)
	touch $(INST)/openstack-full.done

puppetdb-server: $(INST)/puppetdb-server.done
$(INST)/puppetdb-server.done: puppetdb-server.install $(INST)/openstack-common.done
	./puppetdb-server.install $(INST)/openstack-common $(INST)/puppetdb-server $(VERS)
	touch $(INST)/puppetdb-server.done

postgresql-server: $(INST)/postgresql-server.done
$(INST)/postgresql-server.done: postgresql-server.install $(INST)/openstack-common.done functions
	./postgresql-server.install $(INST)/openstack-common $(INST)/postgresql-server $(VERS)
	touch $(INST)/postgresql-server.done

mysql: $(INST)/mysql.done
$(INST)/mysql.done: mysql.install $(INST)/base.done
	./mysql.install $(INST)/base $(INST)/mysql $(VERS)
	touch $(INST)/mysql.done

docker: $(INST)/docker.done
$(INST)/docker.done: docker.install $(INST)/base.done
	./docker.install $(INST)/base $(INST)/docker $(VERS)
	touch $(INST)/docker.done

puppet-master: $(INST)/puppet-master.done
$(INST)/puppet-master.done: puppet-master.install $(INST)/cloud.done functions
	./puppet-master.install $(INST)/cloud $(INST)/puppet-master $(VERS)
	touch $(INST)/puppet-master.done

chef-server: $(INST)/chef-server.done
$(INST)/chef-server.done: chef-server.install $(INST)/base.done
	./chef-server.install $(INST)/base $(INST)/chef-server $(VERS)
	touch $(INST)/chef-server.done

install-server: $(INST)/install-server.done
$(INST)/install-server.done: install-server.install $(INST)/openstack-common.done puppet-master.install $(SDIR)/build/deploy.install postgresql-server.install puppetdb-server.install jenkins.install logcollector.install monitor-server.install tempest.install
	./install-server.install $(INST)/openstack-common $(INST)/install-server $(VERS)
	touch $(INST)/install-server.done

jenkins: $(INST)/jenkins.done
$(INST)/jenkins.done: jenkins.install $(INST)/base.done
	./jenkins.install $(INST)/base $(INST)/jenkins $(VERS)
	touch $(INST)/jenkins.done

tempest: $(INST)/tempest.done
$(INST)/tempest.done: tempest.install $(INST)/base.done
	./tempest.install $(INST)/base $(INST)/tempest $(VERS)
	touch $(INST)/tempest.done

$(INST)/base.done: $(ARCHIVE)/$(BVERS)/base-$(BVERS).edeploy
	rm -rf $(INST)/base
	mkdir -p $(INST)/base
	tar zxf $(ARCHIVE)/$(BVERS)/base-$(BVERS).edeploy -C $(INST)/base
	touch $(INST)/base.done

dist:
	tar zcvf ../edeploy-roles.tgz Makefile README.rst *.install *.exclude

clean:
	-rm -f *~ $(INST)/*.done

distclean: clean
	-rm -rf $(INST)/*

version:
	@echo "$(VERS)"

bversion:
	@echo "$(BVERS)"

.PHONY: cloud devstack openstack-common openstack-full mysql docker puppet-master\
	chef-server logcollector dist clean distclean version monitor-server postgresql-server\
	puppetdb-server
