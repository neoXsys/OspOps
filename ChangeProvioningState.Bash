#!/usr/bin/env bash

## $1 - UUID of OSP Undercloud Baremetal Node with "clean_wait" Provisioning State To Change "available" (openstack baremetal node list | grep clean_wait)"

## Source OSP Undercloud RC file
source ~/stackrc

if [ $# -eq 0 ]
  then
  echo "No arguments supplied"
  echo "Single Argument: UUID of OSP Undercloud Baremetal Node with "clean_wait" Provisioning State To Change Back to "available""
	echo "${0} UUID"
	echo "Available OSP Undercloud Baremetal Node with "clean_wait" Provisioning State"
	openstack baremetal node list | grep clean_wait
  exit 1 
fi

openstack baremetal node maintenance set $1
openstack baremetal node abort $1
openstack baremetal node maintenance unset $1
openstack baremetal node manage $1
openstack baremetal node provide $1

exit 0
