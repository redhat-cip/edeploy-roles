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

In order to list the available roles, type: ``make list``

To build a role just issue ``make <role>``. By default your role will 
be based on the ``base`` role.

In case your role depends on another role, e.g. openstack-full depending
on openstack-common: ``openstack-full → openstack-common → base``, you
can override the default behaviour by setting the ``BASE`` variable:

```
make openstack-full BASE=openstack-common
```

Here are some details about the available roles:

- ceph: Ceph server role (works under Debian Wheezy and Ubuntu 12.04LTS).

  ``make ceph``

- chef-server: Chef server role (works under Ubuntu 12.04LTS).

  ``make chef-server``

- cloud: base role including cloud-init.

  ``make cloud``

- devstack: development role with a devstack installed.

  ``make devstack BASE=cloud``

- docker: Docker role (works under Ubuntu 12.04LTS).

  ``make docker``

- mysql: MySQL server role.

  ``make mysql``

- openstack-common: base role for OpenStack related roles.

  ``make openstack-common``

- openstack-full: all the OpenStack services in one role.

  ``make openstack-full BASE=openstack-common``

- puppet-master: Puppet master role.

  ``make puppet-master``
