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
| Fuel                       | 8.0 release        |
+----------------------------+--------------------+
| OpenStack compatibility    | Liberty            |
+----------------------------+--------------------+
| Operating systems          | Ubuntu 14.04 LTS   |
+----------------------------+--------------------+


Limitations
-----------

Plugin can be enabled only in a new environment. If an environment was
deployed without the plugin, it is impossible to enable and use it there later.

If the Detach RabbitMQ plugin is enabled for an environment, it is impossible
to assign RabbitMQ and Controller roles to the same node.

