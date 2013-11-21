###########################################################################
#
# Spec file for Infinit.e system configuration.
#
Summary: Infinit.e RAID installation for Amazon EC2 m1.xlarge instances
Name: infinit.e-raid10-amazon
Version: INFINITE_VERSION
Release: INFINITE_RELEASE
License: None
Group: Infinit.e
BuildArch: noarch
Prefix: /mnt

%description
Infinit.e RAID 10 installation for Amazon EC2 m1.xlarge instances

###########################################################################
#
# SCRIPTLETS, IN ORDER OF EXECUTION
#

%prep
	# (create build files)
	# (nothing to do)
	#zcat $RPM_SOURCE_DIR/infinit.e-raid-amazon.tgz | tar -xvf -

%pre
	# (Nothing to do)				
	
%post
	if [ -z "$RPM_INSTALL_PREFIX" ]; then
		RPM_INSTALL_PREFIX=/mnt
	fi	

	if [ $1 -eq 1 ]; then
#
# THIS IS AN INSTALL ONLY
#
		echo "Building RAID array with mount point at $RPM_INSTALL_PREFIX"
		
		if [ ! -d $RPM_INSTALL_PREFIX ]; then
			mkdir -p $RPM_INSTALL_PREFIX
		fi

		EXT="ext3"
		if df | grep -q "xvda"; then
			EXT="ext4"
		fi
		umount $RPM_INSTALL_PREFIX >& /dev/null

		# Grab a contiguous block
		NUM_DEVICES=0
		DEVICELIST=
		for dev in b c d e f g h i j k l m; do
			if [ -b /dev/sd$dev ]; then
				umount /dev/sd$dev >& /dev/null
				NUM_DEVICES=$(( $NUM_DEVICES + 1 ))
				DEVICELIST="$DEVICELIST /dev/sd$dev"
			else
				break
			fi
		done
		echo "Found $NUM_DEVICES devices to use for RAID: $DEVICELIST"

		# Install RAID
		mdadm --create /dev/md0 --run --level=10 --homehost=local --name=0 --chunk=256 --raid-devices=$NUM_DEVICES $DEVICELIST
		pvcreate /dev/md0
		vgcreate -s 64M data_vg /dev/md0
		lvcreate -l 100%vg -n data_vol data_vg
		mkfs.${EXT} -m 0 /dev/data_vg/data_vol
		mount -t ${EXT} /dev/data_vg/data_vol $RPM_INSTALL_PREFIX
		
		# Save settings
		#(removed mdadm code - doesn't seem to have any effect)
		sed -i s/"^\/dev\/xvdb"/"\#\/dev\/xvdb"/ /etc/fstab
		sed -i s/"^\/dev\/sdb"/"\#\/dev\/sdb"/ /etc/fstab
		grep -F "/dev/data_vg/data_vol" /etc/fstab || echo "/dev/data_vg/data_vol  $RPM_INSTALL_PREFIX      ${EXT}    defaults,noatime        0 2" >> /etc/fstab
	fi
	if [ $1 -eq 2 ]; then
#
# THIS IS AN UPGRADE NOT AN INSTALL
#
		echo "Upgrade not supported"
	fi
	
%install
#
# INSTALL *AND* UPGRADE
#	
	# (All files created from the tarball)

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
