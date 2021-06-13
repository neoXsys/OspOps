#!/usr/bin/env bash

### Global config ###
OSP_UC_CONFIG=stackrc ## OpenStack undercloud config file

## Import OpenStack undercloud config file 
source ~/$OSP_UC_CONFIG

## Get OpenStack undercloud single / multiple stacks names
STACK_INPUT=$(openstack stack list -f value -c "Stack Name"  --sort-column "Stack Name" | tr '\n ' ',')

## Generate file name from OpenStack undercloud single / multiple stacks names
STACK_NAME=$(openstack stack list -f value -c "Stack Name"  --sort-column "Stack Name" | tr '\n' '-')

## Dynamically generate static inventory (yaml format) for overcloud
/usr/bin/tripleo-ansible-inventory --static-yaml-inventory ~/${STACK_NAME}_StaticIventory.yaml --stack ${STACK_INPUT}

## Dynamically generate inventory (json format) to ansible (Example: ansible -i $0 all -m ping) 
exec /usr/bin/tripleo-ansible-inventory --stack ${STACK_INPUT} --list
