#!/usr/bin/env bash

source ~/stackrc

#Dynamically generate static inventory (yaml format) for overcloud
#exec /usr/bin/tripleo-ansible-inventory --static-yaml-inventory $(openstack stack list -f value -c "Stack Name")StaticIventory.yaml --stack $(openstack stack list -f value -c "Stack Name")

#Dynamically generation nventory (json format) to Ansible (Example: ansible -i $0 all -m ping) 
exec /usr/bin/tripleo-ansible-inventory --stack $(openstack stack list -f value -c "Stack Name") --list
