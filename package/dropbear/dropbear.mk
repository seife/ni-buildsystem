################################################################################
#
# dropbear
#
################################################################################

DROPBEAR_VERSION = 2022.82
DROPBEAR_DIR = dropbear-$(DROPBEAR_VERSION)
DROPBEAR_SOURCE = dropbear-$(DROPBEAR_VERSION).tar.bz2
DROPBEAR_SITE = http://matt.ucc.asn.au/dropbear/releases

DROPBEAR_DEPENDENCIES = zlib

DROPBEAR_CONF_OPTS = \
	--disable-lastlog \
	--disable-wtmp \
	--disable-wtmpx \
	--disable-loginfunc \
	--disable-pam \
	--disable-harden \
	--enable-bundled-libtom

DROPBEAR_MAKE_OPTS = \
	PROGRAMS="dropbear dbclient dropbearkey scp"

define DROPBEAR_INSTALL_INIT_SCRIPT
	$(INSTALL) -d $(TARGET_sysconfdir)/dropbear
	$(INSTALL_EXEC) -D $(PKG_FILES_DIR)/dropbear.init $(TARGET_sysconfdir)/init.d/dropbear
	$(UPDATE-RC.D) dropbear defaults 75 25
endef
DROPBEAR_TARGET_FINALIZE_HOOKS += DROPBEAR_INSTALL_INIT_SCRIPT

dropbear: | $(TARGET_DIR)
	$(call PREPARE)
	$(CHDIR)/$($(PKG)_DIR); \
		$(CONFIGURE); \
		# Ensure that dropbear doesn't use crypt() when it's not available; \
		echo '#if !HAVE_CRYPT'				>> localoptions.h; \
		echo '#define DROPBEAR_SVR_PASSWORD_AUTH 0'	>> localoptions.h; \
		echo '#endif'					>> localoptions.h; \
		# disable SMALL_CODE define; \
		echo '#define DROPBEAR_SMALL_CODE 0'		>> localoptions.h; \
		# fix PATH define; \
		echo '#define DEFAULT_PATH "/sbin:/bin:/usr/sbin:/usr/bin:/var/bin"' >> localoptions.h; \
		$(MAKE) $($(PKG)_MAKE_OPTS) SCPPROGRESS=1; \
		$(MAKE) $($(PKG)_MAKE_OPTS) install DESTDIR=$(TARGET_DIR)
	$(call TARGET_FOLLOWUP)
