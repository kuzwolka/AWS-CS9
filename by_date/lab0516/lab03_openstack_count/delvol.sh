#!/bin/bash


for vol in $(openstack volume list | grep in-use | gawk '{ print $2 }')
do
    openstack volume set --detached $vol
    openstack volume delete $vol
    echo "${vol} is deleted"
done

echo "every volume is killed"
openstack volume list