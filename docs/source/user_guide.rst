
.. _user-guide:

User Guide
==========

#. After plug­in is installed, create a new OpenStack environment.

#. Open the Settings tab of the Fuel web UI and here open Other menu. Select
   "Separate RabbitMQ from controller" checkbox:

   .. image:: _static/enable_plugin.png

#. Go to the Nodes tab and here push Add Nodes button

   .. image:: _static/nodes_tab.png

   Note that now RabbitMQ role is available in the roles list.

#. Create environment with RabbitMQ role assigned to some nodes. On the
   screenshot below you may see environment with 1 controller, 1 compute
   and one RabbitMQ node. You can assign RabbitMQ role to more than one
   node.

   .. image:: _static/env_nodes.png

#. Finish `configuring your environment`_.

#. `Deploy your environment`_.


References
----------

.. target-notes::
.. _configuring your environment: http://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#configure-your-environment
.. _Deploy your environment: http://docs.mirantis.com/openstack/fuel/fuel-7.0/user-guide.html#deploy-changes

