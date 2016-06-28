.. _overview:

Document purpose
================

This document provides instructions for installing, configuring and using
Detach RabbitMQ plugin for Fuel.


Detach RabbitMQ Plugin
----------------------

The Detach RabbitMQ plugin provides ability to install an OpenStack
environment with RabbitMQ deployed on dedicated nodes. RabbitMQ consumes a lot
of CPU time on big environment, and the plugin allows to separate it from other
big consumers running on controller nodes like database or various OpenStack
processes.


Requirements
------------

+----------------------------+--------------------+
| Requirement                | Version/Comment    |
+============================+====================+
| Fuel                       | 9.x release        |
+----------------------------+--------------------+
| OpenStack compatibility    | Mitaka             |
+----------------------------+--------------------+
| Operating systems          | Ubuntu 14.04 LTS   |
+----------------------------+--------------------+


Limitations
-----------

Plugin can be enabled only in a new environment. If an environment was
deployed without the plugin, it is impossible to enable and use it there later.

If the Detach RabbitMQ plugin is enabled for an environment, it is impossible
to assign RabbitMQ and Controller roles to the same node.

There are non-verified plugins, which enable user to install Keystone or
database on separate nodes. These plugins could be used together with Detach
RabbitMQ plugin, but user should ensure that:

 * either RabbitMQ and DB or Keystone roles are assigned to the same nodes
 * or RabbitMQ and DB or Keystone roles are assinged to completely different
   nodes and no node exist, which has two of these roles assigned

For example, it is valid to assign RabbitMQ + Keystone roles to three nodes
in the cluster. A bad example is environment with one RabbitMQ + Keystone
node, one RabbitMQ and one Keystone node (3 nodes in total).
