..
 This work is licensed under a Creative Commons Attribution 3.0 Unported
 License.

 http://creativecommons.org/licenses/by/3.0/legalcode

===================================================
Detach RabbitMQ Plugin for Fuel
===================================================

Problem description
===================

Fuel deploys RabbitMQ on Controller nodes along with MySQL and many OpenStack
processes. Cloud operators need a way to deploy RabbitMQ on separate nodes, so
that it does not fight for system resources with other processes.

Proposed change
===============

Implement a Fuel plugin which deploys RabbitMQ on separate nodes. Plugin
should introduce a new role - RabbitMQ. RabbitMQ should be installed only on
machines marked with that new role.

RabbitMQ should be managed by Pacemaker, just like it is now. To simplify
plugin development, Controller and RabbitMQ nodes should not be compatible.
That way we will be able to create two separate Pacemaker clusters: one for
Controller nodes, and another for RabbitMQ ones.

Alternatives
------------

It also might be implemented as Fuel core functionality.

Data model impact
-----------------

None

REST API impact
---------------

None

Upgrade impact
--------------

Fuel currently supports upgrading of Fuel Master node, so it is necessary to
install a new version of plugin which supports new Fuel release. For now it
is not guaranteed that new versions of the plugin will support environments
deployed by the old version.

Security impact
---------------

None

Notifications impact
--------------------

None

Other end user impact
---------------------

Detach RabbitMQ plugin uses Fuel pluggable architecture. After it is
installed, the user can enable the plugin on the Settings tab of the Fuel
web UI.

Performance Impact
------------------

Deploying RabbitMQ on separate nodes increases RabbitMQ stability and
throughput.

Other deployer impact
---------------------

None

Developer impact
----------------

None

Implementation
==============

Assignee(s)
-----------

- Alex Schultz <aschultz@mirantis.com> - developer
- Bartłomiej Piotrowski <bpiotrowski@mirantis.com> - developer

Work Items
----------

* Create Fuel plugin bundle, which contains deployments scripts, puppet
  modules and metadata
* Test Detach RabbitMQ plugin
* Create Documentation


Dependencies
============

* Fuel 8.0

Testing
=======

* Prepare a test plan
* Test the plugin by deploying environments with all Fuel deployment modes

Documentation Impact
====================

* Deployment Guide
* User Guide (which features the plugin provides, how to use them in the
  deployed OpenStack environment)
* Test Plan
* Test Report

