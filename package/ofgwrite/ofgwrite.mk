################################################################################
#
# ofgwrite
#
################################################################################

OFGWRITE_VERSION = ni-git
OFGWRITE_DIR = $(NI_OFGWRITE)
OFGWRITE_SOURCE = $(NI_OFGWRITE)
OFGWRITE_SITE = https://github.com/neutrino-images

OFGWRITE_MAKE_ENV = \
	$(TARGET_CONFIGURE_ENV)

define OFGWRITE_INSTALL_BINARIES
	$(INSTALL_EXEC) $(PKG_BUILD_DIR)/ofgwrite_bin $(TARGET_bindir)
	$(INSTALL_EXEC) $(PKG_BUILD_DIR)/ofgwrite_caller $(TARGET_bindir)
	$(INSTALL_EXEC) $(PKG_BUILD_DIR)/ofgwrite $(TARGET_bindir)
	$(SED) 's|prefix=.*|prefix=$(prefix)|' $(TARGET_bindir)/ofgwrite
endef
OFGWRITE_PRE_FOLLOWUP_HOOKS += OFGWRITE_INSTALL_BINARIES

ofgwrite: | $(TARGET_DIR)
	$(call generic-package,$(PKG_NO_INSTALL))
