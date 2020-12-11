#
# makefile to build system tools (currently unused in ni-image)
#
# -----------------------------------------------------------------------------

# usbutils-008 needs udev
USBUTILS_VER    = 007
USBUTILS_DIR    = usbutils-$(USBUTILS_VER)
USBUTILS_SOURCE = usbutils-$(USBUTILS_VER).tar.xz
USBUTILS_SITE   = $(KERNEL_MIRROR)/linux/utils/usb/usbutils

$(DL_DIR)/$(USBUTILS_SOURCE):
	$(DOWNLOAD) $(USBUTILS_SITE)/$(USBUTILS_SOURCE)

USBUTILS_PATCH  = usbutils-avoid-dependency-on-bash.patch
USBUTILS_PATCH += usbutils-fix-null-pointer-crash.patch

USBUTILS_DEPS   = libusb-compat

usbutils: $(USBUTILS_DEPS) $(DL_DIR)/$(USBUTILS_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(USBUTILS_DIR)
	$(UNTAR)/$(USBUTILS_SOURCE)
	$(CHDIR)/$(USBUTILS_DIR); \
		$(call apply_patches, $(USBUTILS_PATCH)); \
		$(CONFIGURE) \
			--target=$(TARGET) \
			--prefix=$(prefix) \
			--mandir=$(REMOVE_mandir) \
			--infodir=$(REMOVE_infodir) \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	rm -rf $(TARGET_bindir)/lsusb.py
	rm -rf $(TARGET_bindir)/usbhid-dump
	rm -rf $(TARGET_DIR)/sbin/update-usbids.sh
	rm -rf $(TARGET_datadir)/pkgconfig
	rm -rf $(TARGET_datadir)/usb.ids.gz
	$(REMOVE)/$(USBUTILS_DIR)
	$(TOUCH)

# -----------------------------------------------------------------------------

BINUTILS_VER    = 2.35
BINUTILS_DIR    = binutils-$(BINUTILS_VER)
BINUTILS_SOURCE = binutils-$(BINUTILS_VER).tar.bz2
BINUTILS_SITE   = $(GNU_MIRROR)/binutils

$(DL_DIR)/$(BINUTILS_SOURCE):
	$(DOWNLOAD) $(BINUTILS_SITE)/$(BINUTILS_SOURCE)

BINUTILS_BIN    = objdump objcopy

binutils: $(DL_DIR)/$(BINUTILS_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(BINUTILS_DIR)
	$(UNTAR)/$(BINUTILS_SOURCE)
	$(CHDIR)/$(BINUTILS_DIR); \
		$(CONFIGURE) \
			--target=$(TARGET) \
			--prefix=$(prefix) \
			--disable-multilib \
			--disable-werror \
			--disable-plugins \
			--enable-build-warnings=no \
			--disable-sim \
			--disable-gdb \
			; \
		$(MAKE); \
	for bin in $(BINUTILS_BIN); do \
		$(INSTALL_EXEC) $(BUILD_DIR)/$(BINUTILS_DIR)/binutils/$$bin $(TARGET_bindir)/; \
	done
	$(REMOVE)/$(BINUTILS_DIR)
	$(TOUCH)

# -----------------------------------------------------------------------------

UTIL-LINUX_VER    = 2.36.1
UTIL-LINUX_DIR    = util-linux-$(UTIL-LINUX_VER)
UTIL-LINUX_SOURCE = util-linux-$(UTIL-LINUX_VER).tar.xz
UTIL-LINUX_SITE   = $(KERNEL_MIRROR)/linux/utils/util-linux/v$(basename $(UTIL-LINUX_VER))

$(DL_DIR)/$(UTIL-LINUX_SOURCE):
	$(DOWNLOAD) $(UTIL-LINUX_SITE)/$(UTIL-LINUX_SOURCE)

UTUL-LINUX_DEPS   = ncurses zlib

util-linux: $(UTUL-LINUX_DEPS) $(DL_DIR)/$(UTIL-LINUX_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(UTIL-LINUX_DIR)
	$(UNTAR)/$(UTIL-LINUX_SOURCE)
	$(CHDIR)/$(UTIL-LINUX_DIR); \
		autoreconf -fi; \
		$(CONFIGURE) \
			--prefix=$(base_prefix) \
			--localedir=$(REMOVE_localedir) \
			--mandir=$(REMOVE_mandir) \
			--enable-static \
			--disable-shared \
			--disable-hardlink \
			--disable-gtk-doc \
			\
			--disable-all-programs \
				--enable-fdisks \
				--enable-libfdisk \
				--enable-libsmartcols \
				--enable-libuuid \
			\
			--disable-makeinstall-chown \
			--disable-makeinstall-setuid \
			--disable-makeinstall-chown \
			\
			--without-ncursesw \
			--without-python \
			--without-slang \
			--without-systemd \
			--without-systemdsystemunitdir \
			--without-tinfo \
			--without-udev \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL_LA)
	$(REWRITE_PKGCONF_PC)
	$(REMOVE)/$(UTIL-LINUX_DIR)
	$(TOUCH)

# -----------------------------------------------------------------------------

ASTRA-SM_VER    = git
ASTRA-SM_DIR    = astra-sm.$(ASTRA-SM_VER)
ASTRA-SM_SOURCE = astra-sm.$(ASTRA-SM_VER)
ASTRA-SM_SITE   = https://gitlab.com/crazycat69

ASTRA-SM_DEPS   = openssl

astra-sm: $(ASTRA-SM_DEPS) | $(TARGET_DIR)
	$(REMOVE)/$(ASTRA-SM_DIR)
	$(GET-GIT-SOURCE) $(ASTRA-SM_SITE)/$(ASTRA-SM_SOURCE) $(DL_DIR)/$(ASTRA-SM_SOURCE)
	$(CPDIR)/$(ASTRA-SM_SOURCE)
	$(CHDIR)/$(ASTRA-SM_DIR); \
		autoreconf -fi; \
		sed -i 's:(CFLAGS):(CFLAGS_FOR_BUILD):' tools/Makefile.am; \
		$(CONFIGURE) \
			--prefix=$(prefix) \
			--sysconfdir=$(sysconfdir) \
			--without-lua \
			; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(ASTRA-SM_DIR)
	$(TOUCH)

# -----------------------------------------------------------------------------

IOZONE_VER    = 3_490
IOZONE_DIR    = iozone$(IOZONE_VER)
IOZONE_SOURCE = iozone$(IOZONE_VER).tar
IOZONE_SITE   = http://www.iozone.org/src/current

$(DL_DIR)/$(IOZONE_SOURCE):
	$(DOWNLOAD) $(IOZONE_SITE)/$(IOZONE_SOURCE)

iozone: $(DL_DIR)/$(IOZONE_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(IOZONE_DIR)
	$(UNTAR)/$(IOZONE_SOURCE)
	$(CHDIR)/$(IOZONE_DIR)/src/current; \
		$(SED) "s/= gcc/= $(TARGET_CC)/" makefile; \
		$(SED) "s/= cc/= $(TARGET_CC)/" makefile; \
		$(MAKE_ENV) \
		$(MAKE) linux-arm; \
		$(INSTALL_EXEC) iozone $(TARGET_bindir)/
	$(REMOVE)/$(IOZONE_DIR)
	$(TOUCH)

# -----------------------------------------------------------------------------

READLINE_VER    = 8.0
READLINE_DIR    = readline-$(READLINE_VER)
READLINE_SOURCE = readline-$(READLINE_VER).tar.gz
READLINE_SITE   = $(GNU_MIRROR)/readline

$(DL_DIR)/$(READLINE_SOURCE):
	$(DOWNLOAD) $(READLINE_SITE)/$(READLINE_SOURCE)

readline: $(DL_DIR)/$(READLINE_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(READLINE_DIR)
	$(UNTAR)/$(READLINE_SOURCE)
	$(CHDIR)/$(READLINE_DIR); \
		$(CONFIGURE) \
			--prefix=$(prefix) \
			--datarootdir=$(REMOVE_datarootdir) \
			; \
		$(MAKE) all; \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_PKGCONF_PC)
	$(REMOVE)/$(READLINE_DIR)
	$(TOUCH)

# -----------------------------------------------------------------------------

LIBZEN_VER    = 0.4.38
LIBZEN_TMP    = ZenLib
LIBZEN_SOURCE = libzen_$(LIBZEN_VER).tar.bz2
LIBZEN_SITE   = https://mediaarea.net/download/source/libzen/$(LIBZEN_VER)

$(DL_DIR)/$(LIBZEN_SOURCE):
	$(DOWNLOAD) $(LIBZEN_SITE)/$(LIBZEN_SOURCE)

LIBZEN_DEPS   = zlib

libzen: $(LIBZEN_DEPS) $(DL_DIR)/$(LIBZEN_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(LIBZEN_TMP)
	$(UNTAR)/$(LIBZEN_SOURCE)
	$(CHDIR)/$(LIBZEN_TMP)/Project/GNU/Library; \
		autoreconf -fi; \
		$(CONFIGURE) \
			--prefix=$(prefix) \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL_LA)
	$(REWRITE_PKGCONF_PC)
	$(REMOVE)/$(LIBZEN_TMP)
	$(TOUCH)

# -----------------------------------------------------------------------------

LIBMEDIAINFO_VER    = 20.08
LIBMEDIAINFO_TMP    = MediaInfoLib
LIBMEDIAINFO_SOURCE = libmediainfo_$(LIBMEDIAINFO_VER).tar.bz2
LIBMEDIAINFO_SITE   = https://mediaarea.net/download/source/libmediainfo/$(LIBMEDIAINFO_VER)

$(DL_DIR)/$(LIBMEDIAINFO_SOURCE):
	$(DOWNLOAD) $(LIBMEDIAINFO_SITE)/$(LIBMEDIAINFO_SOURCE)

LIBMEDIAINFO_DEPS   = libzen

libmediainfo: $(LIBMEDIAINFO_DEPS) $(DL_DIR)/$(LIBMEDIAINFO_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(LIBMEDIAINFO_TMP)
	$(UNTAR)/$(LIBMEDIAINFO_SOURCE)
	$(CHDIR)/$(LIBMEDIAINFO_TMP)/Project/GNU/Library; \
		autoreconf -fi; \
		$(CONFIGURE) \
			--prefix=$(prefix) \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REWRITE_LIBTOOL_LA)
	$(REWRITE_PKGCONF_PC)
	$(REMOVE)/$(LIBMEDIAINFO_TMP)
	$(TOUCH)

# -----------------------------------------------------------------------------

MEDIAINFO_VER    = 20.08
MEDIAINFO_TMP    = MediaInfo
MEDIAINFO_SOURCE = mediainfo_$(MEDIAINFO_VER).tar.bz2
MEDIAINFO_SITE   = https://mediaarea.net/download/source/mediainfo/$(MEDIAINFO_VER)

$(DL_DIR)/$(MEDIAINFO_SOURCE):
	$(DOWNLOAD) $(MEDIAINFO_SITE)/$(MEDIAINFO_SOURCE)

MEDIAINFO_DEPS   = libmediainfo

mediainfo: $(MEDIAINFO_DEPS) $(DL_DIR)/$(MEDIAINFO_SOURCE) | $(TARGET_DIR)
	$(REMOVE)/$(MEDIAINFO_TMP)
	$(UNTAR)/$(MEDIAINFO_SOURCE)
	$(CHDIR)/$(MEDIAINFO_TMP)/Project/GNU/CLI; \
		autoreconf -fi; \
		$(CONFIGURE) \
			--prefix=$(prefix) \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(TARGET_DIR)
	$(REMOVE)/$(MEDIAINFO_TMP)
	$(TOUCH)
