#!/usr/bin/env bash

### Reference Article: https://access.redhat.com/articles/6256901
### Global config
OSP_UC_CONFIG=stackrc ## OpenStack undercloud config file
OSP_CASE_ID=$1
MAX_MIB_PER_LOG="250" ## ~ MiB = Mebibyte ~ Megabytes
DATE=$(date '+%Y-%m-%d')

## Arg Check
if [ -z "$1" ]
then
  echo "### No argument supplied"
  echo "### Provide Red Hat Case ID"
  exit 1
fi

## Import OpenStack undercloud config file
source ~/$OSP_UC_CONFIG

## Generate Executiong Log
COLLECT_SOSREPORTS_RHOSP_OC_NODES="CollectSOSReportOfRHOSPOCNodes-$OSP_CASE_ID-$DATE.log"

echo -e "\n" | tee -a $COLLECT_SOSREPORTS_RHOSP_OC_NODES
echo "Red Hat Case ID: $OSP_CASE_ID" | tee -a $COLLECT_SOSREPORTS_RHOSP_OC_NODES
echo "Generate SOS Report Per UC Flavor" | tee -a $COLLECT_SOSREPORTS_RHOSP_OC_NODES

## Collect SOS Reports Per UC Flavor
for OSP_UC_FLAVORS in `openstack server list -f value -c Flavor | sort | uniq | paste -d' ' -s`
do
        IPS_PER_OSP_UC_FLAVORS=`openstack server list --flavor $OSP_UC_FLAVORS -f value -c Networks | cut -f2 -d"=" | paste -d',' -s`
  echo -e "\n" | tee -a $COLLECT_SOSREPORTS_RHOSP_OC_NODES
  echo "SOS Report Collecting for Following RHOSP UC Flavor: $OSP_UC_FLAVORS" | tee -a $COLLECT_SOSREPORTS_RHOSP_OC_NODES
  echo "RHOSP Overcloud Nodes IPs Per Flavor $OSP_UC_FLAVORS: $IPS_PER_OSP_UC_FLAVORS" | tee -a $COLLECT_SOSREPORTS_RHOSP_OC_NODES
  echo "# sos-collector --ssh-user heat-admin --insecure-sudo --cluster-type=none --no-local --nodes=$IPS_PER_OSP_UC_FLAVORS --timeout 1800 --case-id $OSP_CASE_ID --label $OSP_UC_FLAVORS" | tee -a $COLLECT_SOSREPORTS_RHOSP_OC_NODES
done

echo -e "\n" | tee -a $COLLECT_SOSREPORTS_RHOSP_OC_NODES
echo "Upload SOS Reports to Red Hat Support Portal Under Red Hat Case $OSP_CASE_ID" | tee -a $COLLECT_SOSREPORTS_RHOSP_OC_NODES
echo "# mkdir -p /home/stack/sosreports/$DATE/$OSP_CASE_ID" | tee -a $COLLECT_SOSREPORTS_RHOSP_OC_NODES
echo "# ls /var/tmp/sos-collector-*$OSP_CASE_ID*-*$DATE* | xargs -I {} mv  {} /home/stack/sosreports/$DATE/$OSP_CASE_ID/" | tee -a $COLLECT_SOSREPORTS_RHOSP_OC_NODES
echo "# for UPLOAD in \`ls /home/stack/sosreports/$DATE/$OSP_CASE_ID\` ; do redhat-support-tool addattachment -c CASE_NUMBER \$UPLOAD ; done" | tee -a $COLLECT_SOSREPORTS_RHOSP_OC_NODES
echo -e "\n" | tee -a $COLLECT_SOSREPORTS_RHOSP_OC_NODES
echo "Execution Log Available at `pwd`/$COLLECT_SOSREPORTS_RHOSP_OC_NODES"

exit 0
