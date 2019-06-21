#
# makefile to build static libraries
#
# -----------------------------------------------------------------------------

STATIC_LIBS =
ifeq ($(BOXSERIES), $(filter $(BOXSERIES), hd2 hd51 bre2ze4k))
  STATIC_LIBS += cortex-strings
endif

static-libs: $(STATIC_LIBS)

# -----------------------------------------------------------------------------

CORTEX-STRINGS_VER = 48fd30c346ff2ab14ca574b770b5c1bcbefadba8

$(ARCHIVE)/cortex-strings-$(CORTEX-STRINGS_VER).tar.bz2:
	get-git-archive.sh http://git.linaro.org/git-ro/toolchain/cortex-strings.git $(CORTEX-STRINGS_VER) $(notdir $@) $(ARCHIVE)

CORTEX-STRINGS_CONF =
ifneq ($(BOXSERIES), $(filter $(BOXSERIES), hd51 bre2ze4k))
  CORTEX-STRINGS_CONF = --without-neon
endif

cortex-strings: $(STATIC_LIB_DIR)/libcortex-strings.la
$(STATIC_LIB_DIR)/libcortex-strings.la: $(ARCHIVE)/cortex-strings-$(CORTEX-STRINGS_VER).tar.bz2 | $(TARGET_DIR)
	$(REMOVE)/cortex-strings-$(CORTEX-STRINGS_VER)
	$(UNTAR)/cortex-strings-$(CORTEX-STRINGS_VER).tar.bz2
	$(CHDIR)/cortex-strings-$(CORTEX-STRINGS_VER); \
		./autogen.sh; \
		CFLAGS="-pipe -O2 $(TARGET_DEBUGGING) $(CXX11_ABI) -I$(TARGET_INCLUDE_DIR)" \
		CPPFLAGS="-pipe -O2 $(TARGET_DEBUGGING) $(CXX11_ABI) -I$(TARGET_INCLUDE_DIR)" \
		CXXFLAGS="-pipe -O2 $(TARGET_DEBUGGING) $(CXX11_ABI) -I$(TARGET_INCLUDE_DIR)" \
		LDFLAGS="-Wl,-O1 -L$(TARGET_LIB_DIR)" \
		PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
		./configure $(CONFIGURE_OPTS) \
			--prefix= \
			--disable-shared \
			--enable-static \
			$(CORTEX-STRINGS_CONF) \
			; \
		$(MAKE); \
		$(MAKE) install DESTDIR=$(STATIC_DIR)
	$(REWRITE_LIBTOOL_STATIC)/libcortex-strings.la
	$(REMOVE)/cortex-strings-$(CORTEX-STRINGS_VER)

# -----------------------------------------------------------------------------

PHONY += static-libs
PHONY += cortex-strings
