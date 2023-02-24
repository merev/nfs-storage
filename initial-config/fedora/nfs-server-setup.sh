#!/bin/bash

echo "* Install nfs-server packages ..."
dnf install -y nfs-utils

echo "* Make changes in tha main config file ..."
nfsconf --set nfsd vers4 y
nfsconf --set nfsd vers3 n
nfsconf --set nfsd udp n
nfsconf --set nfsd tcp y

echo "* Enable and start the service ..."
systemctl enable --now nfs-server
systemctl mask --now rpcbind.service rpcbind.socket rpc-statd.service

echo "* Create shared directories ..."
mkdir -p /storage/nfs/share

echo "* Generate test files ..."
echo "test file1 nfs server" >> /storage/nfs/share/test-nfs.txt

echo "* Change the ownership and permissions of the directory ..."
chown nobody:nogroup /storage/nfs/share
chmod 777 /storage/nfs/share

echo "* Share the directory with the hosts in the network ..."
echo "/storage/nfs/share  192.168.99.0/24(rw,sync,no_root_squash,no_all_squash,no_subtree_check)" | tee -a /etc/exports

echo "* Apply the changes in /etc/exports ..."
exportfs -rav

echo "* Adjust the firewall settings ..."
firewall-cmd --add-service nfs --permanent
firewall-cmd --reload