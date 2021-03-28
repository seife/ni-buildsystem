################################################################################
#
# libffi
#
################################################################################

LIBFFI_VERSION = 3.3
LIBFFI_DIR = libffi-$(LIBFFI_VERSION)
LIBFFI_SOURCE = libffi-$(LIBFFI_VERSION).tar.gz
LIBFFI_SITE = https://github.com/libffi/libffi/releases/download/v$(HOST_LIBFFI_VERSION)

LIBFFI_AUTORECONF = YES

LIBFFI_CONF_OPTS = \
	--datarootdir=$(REMOVE_datarootdir) \
	$(if $(filter $(BOXSERIES),hd1),--enable-static --disable-shared)

libffi: | $(TARGET_DIR)
	$(call autotools-package)

# -----------------------------------------------------------------------------

HOST_LIBFFI_VERSION = $(LIBFFI_VERSION)
HOST_LIBFFI_DIR = $(LIBFFI_DIR)
HOST_LIBFFI_SOURCE = $(LIBFFI_SOURCE)
HOST_LIBFFI_SITE = $(LIBFFI_SITE)

host-libffi: | $(HOST_DIR)
	$(call host-autotools-package)
