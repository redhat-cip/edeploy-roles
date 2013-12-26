eDeploy-roles
=============

.. contents::

Introduction
------------

eDeploy is a tool to provision and update systems (physical or virtual)
using trees of files instead of packages or VM images. More information
at https://github.com/enovance/edeploy.

eDeploy-roles is a set of tools to build roles to be used with eDeploy.

Roles
-----

To build a role just issue ``make <role>``. The list of available roles:

- ceph: Ceph server role (works under Debian Wheezy and Ubuntu 12.04LTS).
- chef-server: Chef server role (works under Ubuntu 12.04LTS).
- cloud: base role including cloud-init.
- devstack: development role with a devstack installed.
- docker: Docker role (works under Ubuntu 12.04LTS).
- mysql: MySQL server role.
- openstack-common: base role for OpenStack related roles.
- openstack-full: all the OpenStack services in one role.
- puppet-master: Puppet master role.

