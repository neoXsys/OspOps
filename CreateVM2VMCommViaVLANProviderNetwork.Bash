#!/usr/bin/env bash

### Bash script to create VM To VM Communication with VLAN Provider Network for RHOSP 16.2
### Reference Document: https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.2/html-single/networking_guide/index#config_controller_nodes_vlan_connect-instance


### TODO: Define Global Variable ###
### TODO: Checks: NeutronTypeDrivers, NeutronNetworkVLANRanges & NeutronBridgeMappings RHSOP Configurations

### Import overcloudrc file for admin project
source ~/overcloudrc

### Create VLAN Provider Network
### VLAN Provider Network Depends on you DC Fabric / Underlay Network Configuraitons (VLANs & IPs)

openstack network create \
            --provider-network-type vlan \
            --external \
            --provider-physical-network datacentre \
            --provider-segment 101 \
            --share \
            provider-central-101

### Create Subnet of VLAN Provider Network
### VLAN Provider Network Depends on you DC Fabric / Underlay Network Configuraitons (VLANs & IPs)
openstack subnet create \
            --network provider-central-101 \
            --subnet-range 10.10.10.0/24 \
            --allocation-pool start=10.10.10.100,end=10.10.10.110 \
            --dhcp \
            --gateway 10.10.10.1 \
            subnet-provider-central-101

### Create VM Flavor
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

### Spawn 2x Cirros Instances
openstack server create T1 --flavor m1.nano --image $(openstack image list -f value -c ID | head -1) --network $(openstack network show private -f value -c id) --key-name $(openstack keypair list -f value -c Name)
openstack server create T2 --flavor m1.nano --image $(openstack image list -f value -c ID | head -1) --network $(openstack network show private -f value -c id) --key-name $(openstack keypair list -f value -c Name)

### What's going on?
openstack server list
openstack console log show T1 | tail -n20
openstack console log show T2 | tail -n20
openstack server list

### Login to Test Instances Console Via RHOSP Dashboard & Perform Ping & SSH Tests"
echo "Login to Test Instances Console Vai RHOSP Dashboard & Perform Ping & SSH Tests"
