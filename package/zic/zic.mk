################################################################################
#
# zic
#
################################################################################

ZIC_VERSION = 2023c
ZIC_DIR = tzcode$(ZIC_VERSION)
ZIC_SOURCE = tzcode$(ZIC_VERSION).tar.gz
ZIC_SITE = https://data.iana.org/time-zones/releases

# ------------------------------------------------------------------------------

# fix non-existing subdir in tzcode tarball
HOST_ZIC_EXTRACT_DIR = $($(PKG)_DIR)

HOST_ZIC_BINARY = $(HOST_DIR)/sbin/zic

define HOST_ZIC_BUILD_CMDS
	$(CD) $(PKG_BUILD_DIR); \
		$(MAKE) zic
endef

define HOST_ZIC_INSTALL_CMDS
	$(INSTALL_EXEC) -D $(PKG_BUILD_DIR)/zic $(HOST_ZIC_BINARY)
endef

host-zic: | $(HOST_DIR)
	$(call host-generic-package)
