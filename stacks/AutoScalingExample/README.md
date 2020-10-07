# Auto Scalling Demo
## How to run for RHOSP 13?
```openstack stack create  -t  template-osp13.yaml -e environment.yaml AutoScallingDemo```
## How to run for RHOSP 16.1?
```openstack stack create  -t  template-osp161.yaml -e environment.yaml AutoScallingDemo```
## How to scale up instances (Auto Scalling)?
```
ssh cirros@_EXTERNAL_IP_OF_INSTANCE_
sudo dd if=/dev/zero of=/dev/null & sudo dd if=/dev/zero of=/dev/null & sudo dd if=/dev/zero of=/dev/null
``` 
## How to watch auto scalling in live?
```watch -n1 "openstack server list && openstack alarm list"```
## How to scale down instances (Auto Scalling)?
```
ssh cirros@_EXTERNAL_IP_OF_INSTANCE
sudo killall dd
```
## Reference Document
[RHOSP 13: AUTO SCALING FOR INSTANCES](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/13/html-single/auto_scaling_for_instances/index)
[RHOSP 16.1: AUTO SCALING FOR INSTANCES](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/16.1/html-single/auto_scaling_for_instances/index)
