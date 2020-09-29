#!/bin/bash

### TODO: Define Global Variable ###

### Import overcloudrc file for admin project
source ~/overcloudrc

### Crate Public Network
openstack network create public  --external --provider-physical-network datacentre  --provider-network-type flat

### Public / Eternal Network Depends on you DC Fabric / Underlay Network and change IP Range as per the configuration
## openstack subnet create public-subnet  --no-dhcp --network public --subnet-range 192.0.2.0/24  --allocation-pool start=192.0.2.150,end=192.0.2.200  --gateway 192.0.2.254 --dns-nameserver 8.8.8.8

openstack subnet create public-subnet --no-dhcp --network public --subnet-range 10.0.0.0/24 --allocation-pool start=10.0.0.100,end=10.0.0.200  --gateway 10.0.0.1 --dns-nameserver 8.8.8.8

### Create Private Network
openstack network create private
openstack subnet create private-subnet --network private --dns-nameserver 172.16.1.1 --gateway 172.16.1.1 --subnet-range 172.16.1.0/24

### Create Router
openstack router create router1
openstack router add subnet router1 private-subnet
openstack router set router1 --external-gateway public
openstack port list --router=router1

### Create Flavour
openstack flavor create m1.nano --vcpus 1 --ram 64 --disk 1

### Create Security Key stackrc
openstack keypair create --public-key ~/.ssh/id_rsa.pub stackrc

### Enable ICMP & SSH Port in Default Security Group
openstack security group list --project admin
openstack security group rule create --proto icmp $(openstack security group list --project admin -f value -c ID)
openstack security group rule create --dst-port 22 --proto tcp $(openstack security group list --project admin -f value -c ID)

### Download & Upload Cirros Image
#curl -L -O http://download.cirros-cloud.net/0.4.0/cirros-0.4.0-x86_64-disk.img
openstack image create cirros --file cirros-0.4.0-x86_64-disk.img --disk-format qcow2 --container-format bare

### Spawn Cirros Instance
openstack server create test-instance --flavor m1.nano --image $(openstack image list -f value -c ID | head -1) --network $(openstack network show private -f value -c id) --key-name $(openstack keypair list -f value -c Name)

### What's going on?
openstack server list
openstack console log show test-instance | tail -n20


### Create Floating IP
openstack floating ip create public
openstack floating ip list

### Assign Floating IP
openstack server add floating ip test-instance $(openstack floating ip list -f value -c "Floating IP Address" | head -n1)
