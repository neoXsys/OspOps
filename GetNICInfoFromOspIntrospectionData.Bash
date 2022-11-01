#!/usr/bin/env bash

### Author: Hardik 'Hardy' Dalwadi | hdalwadi-|at|-redhat-|dot|-com
## $1 - Script input from OSP Undercloud Node UUID / Name after introspection (openstack baremetal node list)

## Source OSP Undercloud RC file
source ~/stackrc

if [ $# -eq 0 ]
  then
  echo "No arguments supplied"
  echo "Single Argument: OSP Undercloud Node UUID or Name From (openstack baremetal node list)"
  openstack baremetal node list
  echo "Usage: ${0} controller-1/UUID"
  exit 1
fi

echo "BaremetalName/UUID BaremetalName/UUID NICName LinkStatus MacID BusInfo Vendor Product Firmware Driver Speed"
for NICName in $(openstack baremetal introspection interface list ${1} -f value -c Interface)
  do
    LinkStatus=$(openstack baremetal introspection data save ${1} | jq -r '.extra.network["'${NICName}'"].link')
    MACId=$(openstack baremetal introspection data save ${1} | jq -r '.extra.network["'${NICName}'"].serial')
    BUSINFO=$(openstack baremetal introspection data save ${1} | jq -r '.extra.network["'${NICName}'"].businfo')
    VENDOR=$(openstack baremetal introspection data save ${1} | jq -r '.extra.network["'${NICName}'"].vendor')
    PRODUCT=$(openstack baremetal introspection data save ${1} | jq -r '.extra.network["'${NICName}'"].product')
    FIRMWARE=$(openstack baremetal introspection data save ${1} | jq -r '.extra.network["'${NICName}'"].firmware')
    DRIVER=$(openstack baremetal introspection data save ${1} | jq -r '.extra.network["'${NICName}'"].driver')
    SPEED=$(openstack baremetal introspection data save ${1} | jq -r '.extra.network["'${NICName}'"].speed')
    echo ${1} $(openstack baremetal node show ${1} -f value  -c name) ${NICName} ${LinkStatus} ${MACId} ${BUSINFO} ${VENDOR} ${PRODUCT} ${FIRMWARE} ${DRIVER} ${SPEED}
done

exit 0
