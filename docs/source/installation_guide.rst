.. _installation:

Installation Guide
==================

#. Download the plug­in from `Fuel Plugins Catalog`_.

#. Copy the plug­in on already installed Fuel Master node::

      [user@home ~]$ scp detach-rabbitmq-1.0-1.0.1-1.noarch.rpm root@:/
      <the_Fuel_Master_node_IP>:~/

#. Log into the Fuel Master node. Install the plugin::

      [root@fuel ~]# fuel plugins --install detach-rabbitmq-1.0-1.0.1-1.noarch.rpm

#. Verify that the plugin is installed correctly::

      [root@fuel ~]# fuel plugins --list
      id | name            | version | package_version
      ---|-----------------|---------|----------------
      1  | detach-rabbitmq | 1.0.1   | 3.0.0


References
----------

.. target-notes::
.. _Fuel Plugins Catalog: https://www.mirantis.com/products/openstack-drivers-and-plugins/fuel-plugins/

