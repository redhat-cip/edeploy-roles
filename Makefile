#
# Copyright (C) 2013 eNovance SAS <licensing@enovance.com>
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
ARCHIVE=/var/cache/edeploy-roles
DVER=D7
PVER=H
REL=1.2.0
VERSION:=$(PVER).$(REL)
VERS=$(DVER)-$(VERSION)
DIST=wheezy

ARCH=amd64
export PATH := /sbin:/bin::$(PATH)

MAKEFILE_TARGET=$(MAKECMDGOALS)
CURRENT_TARGET=$@
export MAKEFILE_TARGET
export CURRENT_TARGET

INST=$(TOP)/install/$(VERS)
META=$(TOP)/metadata/$(VERS)

ROLES = cloud devstack openstack-common openstack-full mysql ceph puppet-master install-server

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

openstack-common: $(INST)/openstack-common.done
$(INST)/openstack-common.done: openstack-common.install $(INST)/cloud.done
	./openstack-common.install $(INST)/cloud $(INST)/openstack-common $(VERS)
	touch $(INST)/openstack-common.done

openstack-full: $(INST)/openstack-full.done
$(INST)/openstack-full.done: openstack-full.install $(INST)/openstack-common.done
	./openstack-full.install $(INST)/openstack-common $(INST)/openstack-full $(VERS)
	touch $(INST)/openstack-full.done

mysql: $(INST)/mysql.done
$(INST)/mysql.done: mysql.install $(INST)/base.done
	./mysql.install $(INST)/base $(INST)/mysql $(VERS)
	touch $(INST)/mysql.done

ceph: $(INST)/ceph.done
$(INST)/ceph.done: ceph.install $(INST)/base.done
	./ceph.install $(INST)/base $(INST)/ceph $(VERS)
	touch $(INST)/ceph.done

docker: $(INST)/docker.done
$(INST)/docker.done: docker.install $(INST)/base.done
	./docker.install $(INST)/base $(INST)/docker $(VERS)
	touch $(INST)/docker.done

puppet-master: $(INST)/puppet-master.done
$(INST)/puppet-master.done: puppet-master.install $(INST)/cloud.done
	./puppet-master.install $(INST)/cloud $(INST)/puppet-master $(VERS)
	touch $(INST)/puppet-master.done

chef-server: $(INST)/chef-server.done
$(INST)/chef-server.done: chef-server.install $(INST)/base.done
	./chef-server.install $(INST)/base $(INST)/chef-server $(VERS)
	touch $(INST)/chef-server.done

install-server: $(INST)/install-server.done
$(INST)/install-server.done: install-server.install $(INST)/cloud.done
	./install-server.install $(INST)/cloud $(INST)/install-server $(VERS)
	touch $(INST)/install-server.done

$(INST)/base.done:
	mkdir -p $(INST)/base
	tar zxf $(ARCHIVE)/$(VERS)/base-$(VERS).edeploy -C $(INST)/base
	touch $(INST)/base.done

dist:
	tar zcvf ../edeploy-roles.tgz Makefile README.rst *.install *.exclude

clean:
	-rm -f *~ $(INST)/*.done

distclean: clean
	-rm -rf $(INST)/*

version:
	@echo "$(VERS)"

.PHONY: cloud devstack openstack-common openstack-full mysql ceph docker puppet-master\
	chef-server dist clean distclean version
