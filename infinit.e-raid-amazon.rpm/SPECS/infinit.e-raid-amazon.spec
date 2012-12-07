###########################################################################
#
# Spec file for Infinit.e system configuration.
#
Summary: Infinit.e RAID installation for Amazon EC2 m1.xlarge instances
Name: infinit.e-raid-amazon
Version: INFINITE_VERSION
Release: INFINITE_RELEASE
License: None
Group: Infinit.e
BuildArch: noarch
%description
Infinit.e RAID installation for Amazon EC2 m1.xlarge instances

###########################################################################
#
# SCRIPTLETS, IN ORDER OF EXECUTION
#

%prep
	# (create build files)
	# (nothing to do)
	#zcat $RPM_SOURCE_DIR/infinit.e-raid-amazon.tgz | tar -xvf -

%pre
	if [ $1 -eq 1 ]; then
#
# THIS IS AN INSTALL ONLY
#
		EXT="ext3"
		if df | grep -q "xvda"; then
			EXT="ext4"
		fi

		umount /mnt
		mdadm --create /dev/md0 --run --level=0 --chunk=256 --raid-devices=4 /dev/sdb /dev/sdc /dev/sdd /dev/sde
		pvcreate /dev/md0
		vgcreate data_vg /dev/md0
		lvcreate -l 100%vg -n data_vol data_vg
		mkfs.${EXT} -m 0 /dev/data_vg/data_vol
		mount -t ${EXT} /dev/data_vg/data_vol /mnt/
		
		touch /etc/mdadm.conf
		grep -F "/dev/md0" /etc/mdadm.conf || mdadm -Es | grep md0 >> /etc/mdadm.conf
		sed -i s/"^\/dev\/xvdb"/"\#\/dev\/xvdb"/ /etc/fstab
		sed -i s/"^\/dev\/sdb"/"\#\/dev\/sdb"/ /etc/fstab
		grep -F "/dev/data_vg/data_vol" /etc/fstab || echo "/dev/data_vg/data_vol  /mnt      ${EXT}    defaults        0 2" >> /etc/fstab
	fi
	if [ $1 -eq 2 ]; then
#
# THIS IS AN UPGRADE NOT AN INSTALL
#
		# shut down all infinit.e processes (+splunk)
		#create 3 device array
		#mount /tmp
		#copy data across from /mnt
		#umount /mnt /tmp
		#add /dev/sdb to array
		#mount on /mnt
		echo "Upgrade not supported"
	fi
	
%install
#
# INSTALL *AND* UPGRADE
#	
	# (All files created from the tarball)

%post
#
# INSTALL ONLY
#	
	if [ $1 -eq 1 ]; then
		echo "(Nothing more to do)"
	fi
#
# INSTALL *AND* UPGRADE
#	
		
	
%preun
#
# UNINSTALL *AND* UPGRADE
#	
		
	if [ $1 -eq 0 ]; then
#
# THIS IS AN *UN"INSTALL NOT AN UPGRADE
#
		echo "Uninstall not supported"
	fi

%postun
	# (Nothing to do)

%posttrans
#
# FINAL STEP FOR INSTALLS AND UPGRADES
#

###########################################################################
#
# FILE LISTS
#

%files
