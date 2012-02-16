
echo "This script has not yet been tested with 4 devices (previously just created 3 leaving sdb alone)"
echo "First run it in stages to confirm it works, then check back in with exit removed"
exit -1


# 1. CREATE RAID FOR EVERYTHING EXCEPT SDB (/MNT)
echo "Creating RAID array from unused volumes"
mdadm --create /dev/md0 --run --level=0 --chunk=256 --raid-devices=4 /dev/sdc /dev/sdd /dev/sde missing
pvcreate /dev/md0
vgcreate data_vg /dev/md0
lvcreate -l 100%vg -n data_vol data_vg
mkfs.ext3 -m 0 /dev/data_vg/data_vol

#2. MOUNT AND COPY
#(2.1 MOUNT)
echo "Mounting RAID to /tmp/mnt"
mkdir /tmp/mnt
mount -t ext3 /dev/data_vg/data_vol /tmp/mnt/
mkdir /tmp/mnt/tmp || exit -1
#(2.2 STOP ALL PROCESSES)
service tomcat6-interface-engine stop
service infinite-px-engine stop
service infinite-index-engine stop
service splunk stop
#(2.3) COPY ACROSS
cp -rp /mnt/* /tmp/mnt/tmp/

#3. ADD OLD "/MNT" TO VOLUME
echo "Adding old /mnt to RAID volume... please enter 'y' to confirm"
read confirm_plz
if test "$confirm_plz" != "Y" -a "$confirm_plz" != "y"; then exit 0; fi
umount /mnt
umount /tmp/mnt
mdadm --add /dev/md0 /dev/sdb


#4. RE-BALANCE /MNT (MAY NOT BE NECESSARY)
echo "Rebalancing... please enter 'y' to confirm"
read confirm_plz
if test "$confirm_plz" != "Y" -a "$confirm_plz" != "y"; then exit 0; fi
mount -t ext3 /dev/data_vg/data_vol /mnt/
cp -rp /mnt/tmp/* /mnt/
echo "Rebalancing (2)... please enter 'y' to confirm the array has rebalanced (ie you haven't lost any files!)"
read confirm_plz
if test "$confirm_plz" != "Y" -a "$confirm_plz" != "y"; then exit 0; fi
rm -rf /mnt/tmp/

#5. RESTART PROCESSES
service splunk start
service infinite-index-engine start
service infinite-px-engine start
service tomcat6-interface-engine start

#6. FINALLY CONFIGURE START UP MODE
touch /etc/mdadm.conf
grep -F "/dev/md0" /etc/mdadm.conf || mdadm -Es | grep md0 >> /etc/mdadm.conf
sed -i s/"^\/dev\/sdb"/"\#\/dev\/sdb"/ /etc/fstab
grep -F "/dev/data_vg/data_vol" /etc/fstab || echo "/dev/data_vg/data_vol  /mnt      ext3    defaults        1 2" >> /etc/fstab
