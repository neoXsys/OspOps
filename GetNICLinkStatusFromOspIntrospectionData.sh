#!/bin/bash

## $1 - Script input from OSP Undercloud Node UUID / Name after introspection (openstack baremetal node list)

## Source OSP Undercloud RC file
source ~/stackrc

if [ $# -eq 0 ]
  then
  echo "No arguments supplied"
  echo "Single Argument: OSP Undercloud Node UUID or Name (openstack baremetal node list)"
  echo "${0} controller-1"
  exit 1 
fi

for NICName in $(openstack baremetal introspection interface list ${1} -f value -c Interface) 
  do
    LinkStatus=$(openstack baremetal introspection data save ${1} | jq '.extra.network["'${NICName}'"].link') 
    echo ${1} $(openstack baremetal node show ${1} -f value  -c name) ${NICName} ${LinkStatus}
done

exit 0
