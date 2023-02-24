#!/bin/bash

echo "* Install nfs-common packages ..."
apt-get update -y && apt-get install -y nfs-common

echo "* Create a new directory for the mountpoint ..."
mkdir -p /mnt/nfs/share

echo "* Mount the nfs directory ..."
mount -t nfs4 vm3:/storage/nfs/share /mnt/nfs/share

echo "* Verify the NFS mount is successful ..."
df -h

echo "* Read test files (verify read access)..."
cat /mnt/nfs/share/test-nfs.txt

echo "* Generate test files (verify write access) ..."
echo "test file1 nfs client" >> /mnt/nfs/share/test-client.txt

echo "* Mount export on boot ..."
umount /mnt/nfs/share
echo "vm3:/storage/nfs/share   /mnt/nfs/share   nfs4   defaults   0 0" | tee -a /etc/fstab
mount -va