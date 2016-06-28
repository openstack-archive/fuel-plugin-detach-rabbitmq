
.. _installation:

Installation Guide
==================

#. Start with `installing Fuel Master node`_.

#. Download the plugin from `Fuel Plugins Catalog`_.

#. Copy the plugin on already installed Fuel Master node::

      [user@home ~]$ scp detach-rabbitmq-1.1-1.1.1-1.noarch.rpm root@:/
      <the_Fuel_Master_node_IP>:~/

#. Log into the Fuel Master node. Install the plugin::

      [root@fuel ~]# fuel plugins --install detach-rabbitmq-1.1-1.1.1-1.noarch.rpm

#. Verify that the plugin is installed correctly::

      [root@fuel ~]# fuel plugins --list
      id | name            | version | package_version | releases
      ---+-----------------+---------+-----------------+--------------------
      1  | detach-rabbitmq | 1.1.1   | 3.0.0           | ubuntu (mitaka-9.0)


.. target-notes::
.. _installing Fuel Master node: http://docs.openstack.org/developer/fuel-docs/mitaka/userdocs/fuel-install-guide.html
.. _Fuel Plugins Catalog: https://www.mirantis.com/products/openstack-drivers-and-plugins/fuel-plugins/

