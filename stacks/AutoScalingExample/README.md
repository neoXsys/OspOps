# Auto Scalling Demo
## How to run ?
```openstack stack create  -t template.yaml -e environment.yaml AutoScallingDemo```
## How to scale up instances (Auto Scalling)?
```ssh cirros@_EXTERNAL_IP_OF_INSTANCE_```
```sudo dd if=/dev/zero of=/dev/null & sudo dd if=/dev/zero of=/dev/null & sudo dd if=/dev/zero of=/dev/null``` 
## How to watch auto scalling in live?
```watch -n1 "openstack server list && openstack alarm list"```
## How to scale down instances (Auto Scalling)?
```ssh cirros@_EXTERNAL_IP_OF_INSTANCE_```
```sudo killall dd``
## Reference Document
[AUTO SCALING FOR INSTANCES](https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/13/html-single/auto_scaling_for_instances/index)

