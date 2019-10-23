#
# makefile to install system scripts
#
# -----------------------------------------------------------------------------

init-scripts: \
	$(TARGET_DIR)/etc/init.d/globals \
	$(TARGET_DIR)/etc/init.d/functions \
	$(TARGET_DIR)/etc/init.d/camd \
	$(TARGET_DIR)/etc/init.d/camd_datefix \
	$(TARGET_DIR)/etc/init.d/coredump \
	$(TARGET_DIR)/etc/init.d/crond \
	$(TARGET_DIR)/etc/init.d/custom-poweroff \
	$(TARGET_DIR)/etc/init.d/fstab \
	$(TARGET_DIR)/etc/init.d/hostname \
	$(TARGET_DIR)/etc/init.d/inetd \
	$(TARGET_DIR)/etc/init.d/networking \
	$(TARGET_DIR)/etc/init.d/partitions-by-name \
	$(TARGET_DIR)/etc/init.d/resizerootfs \
	$(TARGET_DIR)/etc/init.d/swap \
	$(TARGET_DIR)/etc/init.d/sys_update.sh \
	$(TARGET_DIR)/etc/init.d/syslogd \
	$(TARGET_DIR)/etc/init.d/vuplus-platform-util

$(TARGET_DIR)/etc/init.d/globals:
	$(INSTALL_DATA) -D $(IMAGEFILES)/scripts/init.globals $(@)

$(TARGET_DIR)/etc/init.d/functions:
	$(INSTALL_DATA) -D $(IMAGEFILES)/scripts/init.functions $(@)

$(TARGET_DIR)/etc/init.d/camd:
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/camd.init $(@)
	ln -sf camd $(TARGET_DIR)/etc/init.d/S99camd
	ln -sf camd $(TARGET_DIR)/etc/init.d/K01camd

$(TARGET_DIR)/etc/init.d/camd_datefix:
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/camd_datefix.init $(@)

$(TARGET_DIR)/etc/init.d/coredump:
ifneq ($(BOXMODEL), nevis)
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/coredump.init $(@)
endif

$(TARGET_DIR)/etc/init.d/crond:
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/crond.init $(@)
	ln -sf crond $(TARGET_DIR)/etc/init.d/S55crond
	ln -sf crond $(TARGET_DIR)/etc/init.d/K55crond

$(TARGET_DIR)/etc/init.d/custom-poweroff:
ifeq ($(BOXTYPE), coolstream)
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/custom-poweroff.init $(@)
endif

$(TARGET_DIR)/etc/init.d/fstab:
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/fstab.init $(@)
	ln -sf fstab $(TARGET_DIR)/etc/init.d/S01fstab
	ln -sf fstab $(TARGET_DIR)/etc/init.d/K99fstab

$(TARGET_DIR)/etc/init.d/hostname:
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/hostname.init $(@)

$(TARGET_DIR)/etc/init.d/inetd:
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/inetd.init $(@)
	ln -sf inetd $(TARGET_DIR)/etc/init.d/S53inetd
	ln -sf inetd $(TARGET_DIR)/etc/init.d/K80inetd

$(TARGET_DIR)/etc/init.d/networking:
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/networking.init $(@)
	ln -sf networking $(TARGET_DIR)/etc/init.d/K99networking

$(TARGET_DIR)/etc/init.d/partitions-by-name:
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), hd51 bre2ze4k h7))
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/partitions-by-name.init $(@)
endif

$(TARGET_DIR)/etc/init.d/resizerootfs:
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), hd51 bre2ze4k h7))
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/resizerootfs.init $(@)
endif

$(TARGET_DIR)/etc/init.d/swap:
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), hd51 bre2ze4k h7 vusolo4k vuduo4k vuultimo4k vuzero4k vuuno4k vuuno4kse vuduo))
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/swap.init $(@)
	ln -sf swap $(TARGET_DIR)/etc/init.d/K99swap
endif

$(TARGET_DIR)/etc/init.d/sys_update.sh:
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/sys_update.sh $(@)

$(TARGET_DIR)/etc/init.d/syslogd:
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/syslogd.init $(@)
	ln -sf syslogd $(TARGET_DIR)/etc/init.d/K98syslogd

$(TARGET_DIR)/etc/init.d/vuplus-platform-util:
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), vusolo4k vuduo4k vuultimo4k vuzero4k vuuno4k vuuno4kse))
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/$(BOXMODEL)-platform-util.init $(@)
endif

# -----------------------------------------------------------------------------

scripts: \
	$(TARGET_DIR)/bin/bp3flash.sh \
	$(TARGET_DIR)/sbin/service \
	$(TARGET_DIR)/sbin/flash_eraseall \
	$(TARGET_SHARE_DIR)/udhcpc/default.script

$(TARGET_DIR)/bin/bp3flash.sh:
ifeq ($(BOXMODEL), $(filter $(BOXMODEL), vuduo4k))
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/bp3flash.sh $(@)
endif

$(TARGET_DIR)/sbin/service:
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/service $(@)

$(TARGET_DIR)/sbin/flash_eraseall:
ifeq ($(BOXTYPE), coolstream)
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/flash_eraseall $(@)
endif

$(TARGET_SHARE_DIR)/udhcpc/default.script:
	$(INSTALL_EXEC) -D $(IMAGEFILES)/scripts/udhcpc-default.script $(@)
