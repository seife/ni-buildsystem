#
# makefile to build ni-images; just a collection of targets
#
# -----------------------------------------------------------------------------

BOXMODEL_IMAGE = apollo kronos kronos_v2 hd51
ifneq ($(DEBUG), yes)
	BOXMODEL_IMAGE += nevis
endif

images \
ni-images:
	for boxmodel in $(BOXMODEL_IMAGE); do \
		$(MAKE) BOXMODEL=$${boxmodel} clean image || exit; \
	done;
	make clean

personalized-image:
	make image PERSONALIZE=yes

image \
ni-image:
	@echo "starting 'make $@' build with "$(NUM_CPUS)" threads!"
	make -j$(NUM_CPUS) neutrino
	make plugins-all
	make plugins-$(BOXSERIES)
	make fbshot
	make -j$(NUM_CPUS) luacurl
	make -j$(NUM_CPUS) timezone
	make -j$(NUM_CPUS) smartmontools
	make -j$(NUM_CPUS) sg3-utils
	make -j$(NUM_CPUS) nfs-utils
	make -j$(NUM_CPUS) procps-ng
	make -j$(NUM_CPUS) nano
	make hd-idle
	make -j$(NUM_CPUS) e2fsprogs
	make -j$(NUM_CPUS) ntfs-3g
	make -j$(NUM_CPUS) exfat-utils
	make -j$(NUM_CPUS) vsftpd
	make -j$(NUM_CPUS) djmount
	make -j$(NUM_CPUS) ushare
	make -j$(NUM_CPUS) xupnpd
	make inadyn
	make -j$(NUM_CPUS) samba
	make dropbear
	make -j$(NUM_CPUS) hdparm
	make -j$(NUM_CPUS) busybox
	make -j$(NUM_CPUS) coreutils
	make -j$(NUM_CPUS) dosfstools
	make -j$(NUM_CPUS) wpa_supplicant
	make -j$(NUM_CPUS) mtd-utils
	make -j$(NUM_CPUS) wget
	make -j$(NUM_CPUS) iconv
	make -j$(NUM_CPUS) streamripper
ifeq ($(BOXSERIES), $(filter $(BOXSERIES), hd2 hd51))
	make channellogos
	make -j$(NUM_CPUS) less
	make -j$(NUM_CPUS) parted
	make -j$(NUM_CPUS) openvpn
	make -j$(NUM_CPUS) openssh
	make -j$(NUM_CPUS) ethtool
  ifneq ($(BOXMODEL), kronos_v2)
	make -j$(NUM_CPUS) bash
	make -j$(NUM_CPUS) iperf
	make -j$(NUM_CPUS) minicom
	make -j$(NUM_CPUS) mc
  endif
  ifeq ($(BOXSERIES), hd51)
	make -j$(NUM_CPUS) ofgwrite
	make -j$(NUM_CPUS) aio-grab
	make -j$(NUM_CPUS) dvbsnoop
  endif
  ifeq ($(DEBUG), yes)
	make -j$(NUM_CPUS) strace
	make -j$(NUM_CPUS) valgrind
	make -j$(NUM_CPUS) gdb
  endif
endif
	make -j$(NUM_CPUS) kernel-$(BOXTYPE)-modules
	make autofs5
	make scripts
	make init-scripts
ifeq ($(PERSONALIZE), yes)
	make personalize
endif
	make rootfs
	make flash-image
	@make done

# -----------------------------------------------------------------------------

# Create reversed changelog using git log --reverse.
# Remove duplicated commits and re-reverse the changelog using awk.
# This keeps the original commit and removes all picked duplicates.
define make-changelog
	git log --reverse --pretty=oneline --no-merges --abbrev-commit | \
	awk '!seen[substr($$0,12)]++' | \
	awk '{a[i++]=$$0} END {for (j=i-1; j>=0;) print a[j--]}'
endef

changelogs:
	$(call make-changelog) > $(STAGING_DIR)/changelog-buildsystem
	pushd $(SOURCE_DIR)/$(NI_NEUTRINO); \
		$(call make-changelog) > $(STAGING_DIR)/changelog-neutrino
	pushd $(SOURCE_DIR)/$(NI_LIBSTB-HAL-NEXT); \
		$(call make-changelog) > $(STAGING_DIR)/changelog-libstb-hal

# -----------------------------------------------------------------------------

PHONY += init
PHONY += images ni-images
PHONY += personalized-image
PHONY += image ni-image
PHONY += changelogs
