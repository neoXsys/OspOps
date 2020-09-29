#!/bin/bash

source ~/overcloudrc

openstack server remove floating ip test-instance $(openstack floating ip list -f value -c "Floating IP Address" | head -n1)
openstack floating ip delete $(openstack floating ip list -f value -c "Floating IP Address" | head -n1)
openstack server delete test-instance
openstack keypair delete stackrc
for i in `openstack image list | grep cirros | awk '{print $2}'` ; do openstack image delete $i ; done
openstack flavor delete m1.nano
openstack router unset router1 --external-gateway
openstack router remove subnet router1 private-subnet
openstack router delete router1
openstack subnet delete private-subnet
openstack network delete private
openstack subnet delete public-subnet
openstack network delete public
